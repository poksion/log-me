# encoding: utf-8

require_relative 'category_manager'
require_relative 'category_policy'

class CategoryPolicyCardType < CategoryPolicy
    
    def on_init( category_manager )
        category_manager.add_category("신한카드", "0000ff")
        category_manager.add_category("우리BC카드", "00ff00")
        category_manager.add_category("기타", "ff0000")
    end
    
    def on_add_money( category_manager, category_year, category_month, card_type, used_date, used_content, used_money, dis_count, point)
        if card_type == '신한카드'
            category_manager.add_money("신한카드", category_year, category_month, used_money)
        elsif card_type == '우리BC카드'
            category_manager.add_money("우리BC카드", category_year, category_month, used_money)
        else
            category_manager.add_money("기타", category_year, category_month, used_money)
        end
    end

end
