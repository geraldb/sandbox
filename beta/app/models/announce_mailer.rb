class AnnounceMailer < ActionMailer::Base

  def job_board_digest()
    
    now = Time.now    
    start = now - (now.wday * 60*60*24)     # Sunday starts the week (wday=0 for sunday)

    @subject    = "Vancouver Job Board Digest Week #{now.week} Starting #{start.strftime( '%B/%d' )}"
    @body       = { :posts => Post.recent }
    @recipients = 'vanjobs@googlegroups.com'
    @from       = 'announce@vanbeta.com'
    @sent_on    = Time.now
    @headers    = {}
  end
end
