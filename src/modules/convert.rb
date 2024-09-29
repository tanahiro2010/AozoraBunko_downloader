# frozen_string_literal: true

module Convert
  class CSS
    def ClassToSelector(class_names)
      selector = class_names
      first_word = selector[0]

      if first_word != "." && first_word != " "
        selector = "." + selector
      end

      while selector.include? ' '
        selector = selector.sub ' ', '.'
      end

      selector
    end
  end

  class XPATH

  end
end
