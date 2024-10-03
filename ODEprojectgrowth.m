function Euler
    format long; % Add more decimal places to the values
    clc; % Clear the command window
    fileID1 = fopen('AllData.txt', 'w'); % Designate a file for results
    fileID2 = fopen('project1-y.txt', 'w');
    fileID3 = fopen('project1-exact.txt', 'w');
    fprintf(fileID1, '%6s %12s %12s\r\n', 't', 'y(t)', 'exact(t)');
    fprintf(fileID2, '%6s %12s\r\n', 't', 'y(t)');
    fprintf(fileID3, '%6s %12s\r\n', 't', 'exact(t)');
    
    h = 10; % Define h 
    t_0 = 0; % Define t_0 (corresponds to 1790)
    y_0 = 379; % Define y_0 (initial population in 1790)
    t_n = 220; % Define end of the interval (corresponds to 2010)
    n = ceil((t_n - t_0) / h); % Define the number of iterations required
    t = zeros(n + 1, 1);
    y = zeros(n + 1, 1);
    exact = zeros(n + 1, 1);
    t(1) = t_0; % Save the first value of t into a vector
    y(1) = y_0; % Save the first value of y into a vector
    exact(1) = y_0; % Set exact(1) to the initial population y_0

    for i = 2:n + 1 % Create a loop to solve the iterates
        t(i) = t(i - 1) + h; % Update time
        y(i) = y(i - 1) + h * f(t(i - 1), y(i - 1)); % Euler's method update
        exact(i) = e(t(i)); % Get exact population using e(t)
        fprintf('%6.6f %12.8f %12.8f\r\n', t(i), y(i), exact(i)); % Print to screen
        fprintf(fileID1, '%6.6f %12.8f %12.8f\r\n', t(i), y(i), exact(i));
        fprintf(fileID2, '%6.6f %12.8f\r\n', t(i), y(i));
        fprintf(fileID3, '%6.6f %12.8f\r\n', t(i), exact(i));
    end
    
    fclose(fileID1);
    fclose(fileID2);
    fclose(fileID3);
    
    % Plotting the results
    figure;
    plot(t, y, 'r-*', 'DisplayName', 'Euler Predicted'); % Plot Euler method results
    hold on;
    plot(t, exact, 'b-o', 'DisplayName', 'Exact Solution'); % Plot exact solution
    xlabel('Time (years)');
    ylabel('Population');
    title('Population Growth in Massachusetts (Euler vs Exact)');
    legend;
    grid on;
    hold off;
    
    
    actual_population = [379, 423, 472, 523, 610, 738, 995, 1231, 1457, 1783, 2239, 2805, ...
                         3366, 3852, 4250, 4317, 4691, 5149, 5689, 5737, 6016,6349];

    
    euler_values = y(1:length(actual_population)); 

    
    years = t(1:length(actual_population)); 

    
    residuals = actual_population' - euler_values;

    % Create a table with all the required columns
    result_table = table(years, euler_values, actual_population', residuals, ...
                         'VariableNames', {'Year', 'Euler_Predicted', 'Actual_Population', 'Residuals'});

    % Save the table to an Excel file
    writetable(result_table, 'PopulationResults.xlsx', 'Sheet', 1);

end

function z = f(t, y)
    r = 0.0145225; % Growth rate
    z = r * y; % The rate of change of the population
end

function w = e(t)
    w = 379 * exp(0.0145225 * t); % Exact solution of the exponential growth model
end



