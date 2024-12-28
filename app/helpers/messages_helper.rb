module MessagesHelper
  def message_time_format(time)
    if time.today?
      time.strftime("%H.%M")
    elsif time > 1.day.ago
      "Yesterday at #{time.strftime("%H.%M")}"
    else
      time_ago_in_words(time) + ' ago'
    end
  end
end
