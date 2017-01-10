# encoding: utf-8

class ConsumingCategory
    def initialize( name, color )
        @values = Hash.new { |hash, key| hash[key] ={} }
        @name = name
        @color = color
    end

    def init(year, month)
        @values[year][month] = 0
    end
        
    def add_money(year, month, money)
        @values[year][month] += money
    end
    
    def get_name
        return @name
    end
    
    def get_color
        return @color
    end
    
    def get_values
        return @values
    end
end

class CategoryManager
    def initialize
        @categories = {}
        @priority = []
    end
    
    def add_category( legend, color )
        @categories[legend] = ConsumingCategory.new(legend,color)
        @priority << legend
    end
    
    def add_date( year, month )
        @categories.each do |key, value|
            value.init(year, month)
        end
    end

    def add_money( legend, year, month, money)
        @categories[legend].add_money(year, month, money)
    end
    
    def build_report_info( report_type )
        @report_type = report_type
        @legends = Array.new
        @colors = ""
        @total_data = Array.new
        @labels = Array.new
        @priority.each do | legend |
            category = @categories[legend]
            @legends << category.get_name
            @colors = @colors + "," + category.get_color

            category_data = Array.new
            values = category.get_values
            values.each do | year, month_money |
                label = Array.new
                month_money.each do | month, money |
                    category_data << money
                    axis_element = "#{month}월"
                    if label.empty?
                        axis_element = "#{year}. #{axis_element}"
                    end
                    label << axis_element
                end
                @labels.concat( label )
            end
            @total_data << category_data
        end
        @colors[0] = ''
    end
    
    def get_gchart_type
        return @report_type
    end

    def get_gchart_color
        return @colors
    end

    def get_gchart_data
        if @report_type == 'bar'
            return @total_data
        elsif @report_type == 'pie'
            data = Array.new
            @total_data.each do | timeline_data |
                pie_data = 0
                timeline_data.each do | element_data |
                    pie_data = pie_data + element_data
                end
                data << pie_data
            end
            return data
        end
    end
    
    def get_gchart_legend
        return @legends
    end
    
    def get_gchart_labels
        labels = Array.new
        if @report_type == 'bar'
            labels[0] = @labels;
        elsif @report_type == 'pie'
            label = Array.new
            i = 0
            @total_data.each do | timeline_data |
                pie_data = 0
                timeline_data.each do | element_data |
                    pie_data = pie_data + element_data
                end
                pie_data_string = pie_data.to_s.reverse.scan(/.{1,3}/).join(",").reverse
                label << "#{@legends[i]} - 총 사용 금액 : #{pie_data_string}원"
                i = i + 1
            end

            labels[0] = label
        end
        return labels
    end
    
    def get_gchart_range
        max_money = 0
        i = 0
        while i < @total_data[0].size do
            j = 0
            sum = 0
            while j < @total_data.size do
                sum = sum + @total_data[j][i]
                j = j+1
            end
            if sum > max_money
                max_money = sum
            end
            i = i + 1
        end
        return [nil, [0, max_money, 1000000]]
    end
    
    @@bar_size = 35
    @@bar_space = 7
    def get_gchart_width_and_space
        return "#{@@bar_size},#{@@bar_space}"
    end
    
    def get_gchart_size
        if @report_type == 'bar'
            width = (@@bar_size + @@bar_space) * @total_data[0].size + 170
            if width > 1000
                width = 1000
            end
            return "#{width}x300"
        elsif @report_type == 'pie'
            return "900x300"
        end
    end
end
