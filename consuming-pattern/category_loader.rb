# encoding: utf-8

require_relative 'category_manager'
require_relative 'category_policy'
require 'csv'

class CategoryLoader
    
    def load( category_manager, category_policy )
        @category_inited = false

#        read_data(category_manager, category_policy, 2012)
        read_data(category_manager, category_policy, 2013)

    end

    def read_data( category_manager, category_policy, year )
        for i in 1..12
            file_name = year.to_s + "%02d"%i + ".csv"
            if File.exist?(file_name)
                need_add_date = true
                csv_string = File.open(file_name) { |file| file.read.encode("UTF-8", "UTF-8", invalid: :replace) }
                CSV.parse(csv_string) do |row|
                    add_money(category_manager, category_policy, need_add_date, year, i, row)
                    need_add_date = false
                end
            end
        end
    end

    def add_money(category_manager, category_policy, need_add_date, year, month, row)

        if need_add_date
            unless @category_inited
                @category_inited = true
                category_policy.on_init(category_manager)
            end
            category_manager.add_date(year, month)
        end

        #0 : 카드종류
        #1 : 날짜
        #2 : 내용
        #3 : 금액
        #4 : 할인혜택
        #5 : 포인트적립
        if row[2] == nil
            return
        end

        if row[3] == nil
            money = 0
        else
            money = row[3].delete(',').to_i
        end
        category_policy.on_add_money(category_manager, year, month, row[0], row[1], row[2], money, row[4], row[5])
    end

end
