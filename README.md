Pivotal Tracker Story Labels
=========

Tiny app to add `[ID]` labels to Pivotal Tracker stories. The ID increments globally per project by just selecting the largest already present and adding one to it. There is no attempt to optimise but so far works OK with projects with up to a few hundred stories.

Here's the crontab I've been using (replace `[APIKEY]` with your Tracker key, 
`[PROJECT]` with your project ID, and `[prefix]` with a prefix for the labels, 
e.g. an acronym of the project name
):

    34 * * * * bash -c 'source ~/.rvm/scripts/rvm && 
      cd ~/dev/ruby/pt-labels && rvm use 1.9.2 && 
      ./bin/update [APIKEY] [PROJECT] [prefix] 2>&1 > ~/tmp/pt-cfid.log'
