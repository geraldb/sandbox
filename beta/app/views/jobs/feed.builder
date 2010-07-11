xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

  xml.title       "Vancouver Job/Gigs Board"
  xml.link        feed_jobs_url 
  xml.description "Joint Vancouver Job/Gigs Board - Full Time, Part Time, Contract - Design, Development, Business/Exec"

  @posts.each do |post|
    xml.item do
      xml.title       "#{post.title} @ #{post.company}"
      xml.link        job_url( :permalink => post.to_permalink ) 
      xml.description "More @ #{job_url( :permalink => post.to_permalink )}"
      xml.guid        job_url( :permalink => post.to_permalink ) 
     end
  end
  xml.item do
    xml.title "Add Your Job Posting"
    xml.link    jobs_url
    xml.description "Joint Vancouver Job/Gigs Board - Full Time, Part Time, Contract - Design, Development, Business/Exec"
    xml.guid    jobs_url
  end

  end
end