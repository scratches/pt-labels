require 'pivotal-tracker'

class Client

  attr_accessor :project,:key,:total,:tag

  def initialize(key, project, tag)
    @key = key
    PivotalTracker::Client.token = key
    @project = project
    @tag = tag
  end

  def update(opts={})
    num = find_max + 1
    iterate(opts) do |s|
      if needs_id?(s)
        name = "[#{tag}-#{num}] #{s.name}"
        puts "updating: #{name}"
        s.update(:name=>name)
        num = num + 1
      end
    end
  end

  def needs_id?(story)
    puts "checking: #{story.name}"
    story.story_type != 'release' && !story.name.match(/\[#{tag}-([0-9]*)\]/)
  end

  def find_max
    max = 1;
    iterate do |s|
      match = s.name.match /\[#{tag}-([0-9]*)\]/
      if match
        num = match[1].to_i
        max = max < num ? num : max
      end
    end
    max
  end

  def total
    unless @total
      xml = PivotalTracker::Client.connection["/projects/#{project}/stories?limit=1"].get
      node = XML::Parser.string(xml).parse.root
      @total = node.attributes['total'].to_i
    end
    @total
  end

  def iterate(opts={},&block)
    limit = opts[:limit] ? opts[:limit] : 100
    offset = opts[:offset] ? opts[:offset] : 0
    args = opts.clone
    args[:limit] = limit
    args[:offset] = offset
    max = total
    while offset < max
      args[:offset] = offset
      pivotal = PivotalTracker::Project.find(project)
      stories = pivotal.stories.all(args)
      stories.each { |s| yield s }
      if ! opts[:limit]
        offset = offset + limit
      else
        offset = max
      end
    end
  end

end
