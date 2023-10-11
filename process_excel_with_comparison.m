function process_excel_with_comparison(file_path, column_index, Remaining_data, digital_groups_number)
    % 读取Excel文件
    [~, ~, raw_data] = xlsread(file_path);

    % 获取要处理的列的数据
    column_data = raw_data(:, column_index);

    % 移除非数值数据
    column_data = column_data(cellfun(@(x) isnumeric(x) || isfloat(x), column_data));

    % 定义新列的起始位置
    new_column_index = size(raw_data, 2) + 1; % 新列在最后一列的下一列

    while length(column_data) >= digital_groups_number
        % 每 digital_groups_number 个数据求平均值并添加到新列
        data_length = length(column_data);
        if data_length >= digital_groups_number
            averaged_values = zeros(1, ceil(data_length/digital_groups_number));
            for i = 1:digital_groups_number:data_length
                end_index = min(i+digital_groups_number-1, data_length);
                data_block = cell2mat(column_data(i:end_index));
                averaged_values((i+digital_groups_number-1)/digital_groups_number) = mean(data_block(:));
            end
        else
            averaged_values = mean(cell2mat(column_data));
        end

        for i = 1:length(averaged_values)
            raw_data{i, new_column_index} = averaged_values(i);
        end

        % 更新数据列为新列
        column_data = num2cell(averaged_values');

        % 更新新列的索引
        new_column_index = new_column_index + 1;

        % 检查剩余数据量
        if length(column_data) < Remaining_data
            break;
        end
    end

    % 获取最后一列的列号
    last_column_index = new_column_index - 1;

    % 在最后一列的下一列进行数据对比并输出
    for i = 1:length(column_data)
        current_value = column_data{i};
        min_difference = inf;
        matching_row = 0;

        % 遍历初始数据中的列
        for j = 1:size(raw_data, 1)
            compare_value = raw_data{j, column_index}; % 获取初始数据的值
            if isnumeric(compare_value) || isfloat(compare_value)
                difference = abs(current_value - compare_value);
                if difference < min_difference
                    min_difference = difference;
                    matching_row = j;
                end
            end
        end

        % 更新与最接近的初始数据所在行的列
        if matching_row > 0
            raw_data{i, new_column_index} = matching_row;
        else
            raw_data{i, new_column_index} = 'No match found';
        end
    end

    % 保存修改后的Excel文件
    xlswrite(file_path, raw_data);
end
