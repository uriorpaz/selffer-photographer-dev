module EventTypeHelper
  def get_text_from_type type
    case type
    when 'priv'
      "Private photos (<span id='priv_photo_count'>#{@priv_count}</span>)"
    when 'not_priv'
      "Public photos (<span id='not_priv_photo_count'>#{@all_count - @priv_count}</span>)"
    when 'like'
      "Like (<span id='like_photo_count'>#{@like_count}</span>)"
    when 'album'
      "Photos for album (<span id='album_photo_count'>#{@album_count}</span>)"
    when 'backgrounds'
      "Cover photos (<span id='bg_photo_count'>#{@bg_count}</span>)"
    else
      "All Photos (<span id='all_photo_count'>#{@all_count}</span>)"
    end
  end

  def change_tag_if_hebrew tag, count
    rezult = ["#{URI.decode(tag)}","(#{tag_span(tag, count)})"]
    rezult.reverse! if tag=~/\p{Hebrew}/
    rezult.join(' ').html_safe
  end

  def tag_span tag, count
    content_tag(:span, "#{count}", data: {tag: tag})
  end
end