module ApplicationHelper
  def state_icon(state)
    case state
    when :active then "💧"
    when :chilled then "❄️"
    when :frozen then "🧊" 
    when :deep_frozen then "🏔️"
    else "📄"
    end
  end

  def state_color(state)
    case state
    when :active then "primary"
    when :chilled then "info"
    when :frozen then "warning"
    when :deep_frozen then "secondary"
    else "dark"
    end
  end

  def fragmentation_color(percentage)
    if percentage > 70
      "bg-danger"
    elsif percentage > 40
      "bg-warning"
    else
      "bg-success"
    end
  end

  def heat_color(score)
    if score > 80
      "bg-danger"
    elsif score > 50
      "bg-warning"
    elsif score > 20
      "bg-info"
    else
      "bg-secondary"
    end
  end

  def season_icon(season)
    case season
    when :spring then "🌸"
    when :summer then "☀️"
    when :autumn then "🍂"
    when :winter then "⛄️"
    else "🎯"
    end
  end
end
