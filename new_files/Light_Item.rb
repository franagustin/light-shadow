class Light_Item

  def initialize(items_hash)
    @items_hash = items_hash
    @inverted_items = items_hash.invert
    @percentages = items_hash.values.sort
    sum = @percentages.inject(0) {|sum, i| sum + i}
    if sum < 100
      @items_hash[nil] = @items_hash[nil] || 0 + 100 - sum
    end
  end

  def get_random_item
    result = rand(100)
    i = 0
    @percentages.each { |current|
      old_sum = i
      i += current
      return current if old_sum <= result && result < i
    }
  end

  def give_item
    return false if !Shadow_Utilities.prompt_for_unhide if $Trainer.hidden?
    random_item = @inverted_items[self.get_random_item]
    Kernel.pbMessage(_INTL(
      "You light up this zone using the powers of light and..."
    ))
    if random_item.nil?
      Kernel.pbMessage(_INTL("You find nothing."))
    else
      Kernel.pbItemBall(random_item)
    end
    return true
  end

  def sun_crest
    if Kernel.pbConfirmMessage(_INTL("Want to light up this zone?"))
      return self.give_item
    end
  end

end
