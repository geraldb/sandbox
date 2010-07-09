module NotesHelper

 def is_my_note?( note, &block )
     yield if note.fb_user_id.to_i == @current_fb_user_id.to_i
   end
   
end
