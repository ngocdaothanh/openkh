# -*- coding: utf-8 -*-

module ApplicationHelper
  if CONF[:locale] == 'vi'
    def current_user_block_with_vietnamese_ime(block)
      ret = current_user_block_without_vietnamese_ime(block)

      # ret[1] is in the form <ul>...</ul>
      # We insert the Vietnamese IME as the last <li>
      li = render('vietnamese/ime')
      ret[1].insert(ret[1].length - 5 - 1, li)

      ret
    end
    alias_method_chain :current_user_block, :vietnamese_ime
  end

  # Sorry, many Vietnamese people need this.
  def vietnamese_smart_questions
    return '' unless CONF[:locale] == 'vi'
    'Xin gõ tiếng Việt có dấu để người khác dễ đọc, kiểu gõ chọn ở phía trên cùng. Xin đọc <a href="http://forum.vnoss.org/pub/smart-questions-vi.html">Đặt câu hỏi thông minh như thế nào</a> để thêm kinh nghiệm ứng xử.'
  end

  # Sorry, many Vietnamese people need this.
  def vietnamese_writing_instructions
    return '' unless CONF[:locale] == 'vi'
    <<-EOL
<p>#{vietnamese_smart_questions}</p>
<p>Nến tránh viết tắt. <b>Dấu câu nên viết vào sát chữ trước nó, dấu câu và chữ sau nó nên cách một khoảng trắng.</b></p>
<ul>
  <li>"Tôi là Hòa . Tôi là sinh viên.Bạn tên gì ?" --> "Tôi là Hòa. Tôi là sinh viên. Bạn tên gì?"</li>
  <li>"2 lựa chọn : bút , thước" --> "2 lựa chọn: bút, thước"</li>
</ul>
EOL
  end
end
