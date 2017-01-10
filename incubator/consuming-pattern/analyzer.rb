# encoding: utf-8

require_relative 'category_manager'
require_relative 'category_policy_cardtype'
require_relative 'category_policy_usedcontent'
require_relative 'category_loader'
require 'gchart'

=begin
시간 그래프(카테고리) - 비중 그래프 (카테고리)
시간 그래프(카드) - 비중 그래프 (카드)
=end

def make_report
    
    # type
    report_types = { :bar => 'bar', :pie => 'pie' }
    current_type = :pie
    chart_file_name = report_types[current_type] + '_char.png'

    category_manager = CategoryManager.new
    if current_type == :bar
        category_policy = CategoryPolicyCardType.new
    else
        category_policy = CategoryPolicyUsedContent.new
    end
    category_loader = CategoryLoader.new
    category_loader.load(category_manager,category_policy)

    category_manager.build_report_info(report_types[current_type])
    chart = Gchart.new( :type => category_manager.get_gchart_type,
                        :title => "",
                        :theme => :keynote,
                        :data => category_manager.get_gchart_data,
                        :line_colors => category_manager.get_gchart_color,
                        :legend => category_manager.get_gchart_legend,
                        :axis_with_labels => ['x', 'y'],
                        :axis_labels => category_manager.get_gchart_labels,
                        :axis_range => category_manager.get_gchart_range,
                        :bar_width_and_spacing => category_manager.get_gchart_width_and_space,
                        :size => category_manager.get_gchart_size,
                        :filename => chart_file_name)
    chart.file

    `open #{chart_file_name}`
end

if __FILE__ == $0
    make_report
end
