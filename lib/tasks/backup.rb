namespace :backup do

  desc "Configure your source backup git repository"
  task :config do
    unless bk_remote.empty? || bk_repo.empty? || bk_branch.empty?
      unless `git remote`.include? bk_remote
        puts "\n## Adding new git remote #{bk_remote} for backup."
        system "git remote add #{bk_remote} #{bk_repo}"
      else
        puts "\n## You already have a remote called #{bk_remote}.\n## Update your rake file or use `rake backup:push` to backup your project."
      end
    else
      puts "\nOne of your backup configurations is empty."
    end
  end

  desc "Backup your source to a remote git repository"
  task :push do
    unless bk_remote.empty? || bk_repo.empty? || bk_branch.empty?
      if `git remote`.include? bk_remote
        system "git add ."
        system "git add -u"
        puts "\n## Commiting: Site backed up to #{bk_branch} on #{bk_repo} at #{Time.now.utc}"
        message = "Site backed up at #{Time.now.utc}"
        system "git commit -m \"#{message}\""
        system "git push #{bk_remote} #{bk_branch} --force"
      else
        puts "\n## Run `rake backup:config` to setup your backup git repository first."
      end
    else
      puts "\nOne of your backup configurations is empty."
    end
  end

end
