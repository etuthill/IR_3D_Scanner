% defined outer points using CAD
point0 = [0,0];
point1 = [2.992676, 8.222310];
point2 = [9.992676, 8.222310];
point3 = [12.985353, 0];
point4 = [11.123041, 0];
point5 = [10.041209, 2.972310];
point6 = [2.994144, 2.972310];
point7 = [1.862311, 0];

% turn into x and y coords
x_outer = [point0(1), point1(1), point2(1), point3(1), point4(1), point5(1), point6(1), point7(1), 0];
y_outer = [point0(2), point1(2), point2(2), point3(2), point4(2), point5(2), point6(2), point7(2), 0];

% defined inner points using CAD
innerpoint0 = [3.581092, 4.722310];
innerpoint1 = [4.218039, 6.472310];
innerpoint2 = [8.767313, 6.472310];
innerpoint3 = [9.404261, 4.722310];

% turn into x and y coords
x_inner = [innerpoint0(1), innerpoint1(1), innerpoint2(1), innerpoint3(1), innerpoint0(1)];
y_inner = [innerpoint0(2), innerpoint1(2), innerpoint2(2), innerpoint3(2), innerpoint0(2)];

% make plots
plot(x_outer, y_outer, "r", "LineWidth", 2)
hold on
plot(x_inner, y_inner, "r", "LineWidth", 2)
title("Known Shape Dimensions")
xlabel("x dimension (in)")
ylabel("y dimension (in)")
