module ApplicationHelper
  def pagination(current, last)
    delta = 2
    left = current - delta
    right = current + delta + 1
    range = []
    range_with_dots = []
    l = nil

    (1..last).each do |i|
      if i == 1 || i == last || (i >= left && i < right)
        range.push(i)
      end
    end

    range.each do |i|
      if l
        if i - l == 2
          range_with_dots.push(l + 1)
        elsif i - l != 1
          range_with_dots.push('...')
        end
      end
      range_with_dots.push(i)
      l = i
    end

    range_with_dots
  end
end
