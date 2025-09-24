% hand measured data
dis = [8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36];
IR = [581, 495, 409, 352, 311, 280, 256, 233, 217, 197, 184, 172, 163, 157, 152];

% create fit line
f = fit(dis', IR', "power1");

% make plot
figure
plot(dis, IR, "o")
hold on
syms x
y = 3985*x^-0.9182;
fplot(y)
xlabel('Distance (in)')
ylabel('IR')
title('IR vs Distance')
legend('Measured', 'Line of Best Fit')
xlim([0 38])
ylim([140 790])


%%

% hand measured data
dis_2 = [9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35];
IR_2 = [541, 448, 380, 330, 295, 268, 245, 226, 205, 189, 177, 168, 160, 156];  

% predict ir values at test distances using fit
pred_IR = f(dis_2');  

% fit line
pred_dis = (3985 ./ IR_2).^(1/0.9182);  

% plot
error = pred_dis - dis_2;  
figure
plot(dis_2, error, 'o-')
xlim([6 39])
xlabel('Actual Distance (in)')
ylabel('Prediction Error (in)')
title('Error of Predicted Distance for Test Points')
