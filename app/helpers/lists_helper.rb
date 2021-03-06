module ListsHelper
  # def total_sum(current_user, list)
  #   sum = number_with_precision(list.total_sum, precision: 2)
  #   if !(list.currency.blank?) && (list.currency != current_user.currency)
  #     sum_in_cents = sum.to_f * 100
  #     money = Money.new(sum_in_cents, list.currency)
  #     money = money.exchange_to(current_user.currency)
  #     sum = sum + ' ' + list.currency + '/' + money + ' ' + current_user.currency
  #   else
  #     sum = sum + ' ' + current_user.currency
  #   end
  # end

  # def items_sum(current_user, items, list)
  #   sum = number_with_precision(items.map(&:price).sum, precision: 2)
  #   if !(list.currency.blank?) && (list.currency != current_user.currency)
  #     sum_in_cents = sum.to_f * 100
  #     money = Money.new(sum_in_cents, list.currency)
  #     money = money.exchange_to(current_user.currency)
  #     sum = sum + ' ' + list.currency + '/' + money + ' ' + current_user.currency
  #   else
  #     sum = sum + ' ' + current_user.currency
  #   end
  # end

  def total_items_sum(current_user, list, items=nil)
    if items
      sum = number_with_precision(items.map(&:price).sum, precision: 2)
    else
      sum = number_with_precision(list.total_sum, precision: 2)
    end
    if !(list.currency.blank?) && (list.currency != current_user.currency)
      sum_in_cents = sum.to_f * 100
      money = Money.new(sum_in_cents, list.currency)
      money = money.exchange_to(current_user.currency)
      sum = sum + ' ' + list.currency + '/' + money + ' ' + current_user.currency
    else
      sum = sum + ' ' + current_user.currency
    end
  end

  # def item_sum(current_user, item)
  #   sum = number_with_precision(item.price, precision: 2)
  #   if !(item.list.currency.blank?) && (item.list.currency != current_user.currency)
  #     sum_in_cents = sum.to_f * 100
  #     money = Money.new(sum_in_cents, item.list.currency)
  #     money = money.exchange_to(current_user.currency)
  #     sum = sum + ' ' + item.list.currency + '/' + money + ' ' + current_user.currency
  #   else
  #     sum = sum + ' ' + current_user.currency
  #   end
  # end

  # def item_link(item)
  #   if item.done
  #     link = '<a tabindex="0" role="button" data-toggle="popover"'
  #     link << ' data-placement="top" data-trigger="focus" '
  #     link << ' data-content="Price '+format_price(item)+'">'
  #     link << '<strong>'+item.name+'</strong></a>'
  #     link.html_safe
  #   else
  #     raw '<strong>'+item.name+'</strong>'
  #   end
  # end

  # def format_price(item)
  #   price = item.price.nil? ? 0 : item.price
  #   number_to_currency(price, unit: item.list.currency, format: "%n %u")
  # end
  
end
