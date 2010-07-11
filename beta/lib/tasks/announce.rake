namespace :mail do

  desc "Send weekly job board digest"
  task :job_board_digest => :environment do |t|

    puts AnnounceMailer.create_job_board_digest

    AnnounceMailer.deliver_job_board_digest
  end  

end

