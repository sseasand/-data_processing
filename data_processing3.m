% -data_processing
clc;
%process_excel文件所在路径
addpath('C:\Users\29942\Desktop\数据简化用2')

% 调用函数并传入Excel $文件路径$
file_path = 'C:\Users\29942\Desktop\数据简化用2\111.xlsx';

%要处理的列索引（从1开始）
column_index = 1;%请暂时将数据先放在第一列

%最后剩余的数据量（小于等于）
Remaining_data=30;

%每几个取平均值
digital_groups_number=5;

process_excel_with_comparison(file_path, column_index, Remaining_data, digital_groups_number)
disp('finsh')

% 打开处理后的Excel文件
winopen(file_path);
