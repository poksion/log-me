require 'gchart'
require 'csv'

$data = []
def readFile
    first_category = [17, 17, 11, 8, 2]
    $data.push(first_category)
    
    second_category = [10, 20, 15, 5, 7]
    $data.push(second_category)

    third_category = [2, 3, 7, 9, 12]
    $data.push(third_category)

end

def drawLineAndOpen
    chart = Gchart.new( :type => 'bar',
                        :title => "카드 소비 분석",
                        :theme => :keynote,
                        :data => $data,
                        :line_colors => 'ff0000,00ff00,0000ff',
                        :legend => ['courbe 1','courbe 2','courbe 3'],
                        :axis_with_labels => ['x', 'y'],
                        :axis_labels => [['A', 'B', 'C', 'D', 'E']],
#                        :axis_range => [nil, [0,20,5]],
                        :filename => "chart.png")
    chart.file
    `open chart.png`
end

if __FILE__ == $0
    readFile
    drawLineAndOpen
end