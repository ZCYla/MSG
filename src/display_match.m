function display_match(img1, img2, cleanedPoints1, cleanedPoints2, mode)
% 显示两幅图像中的匹配特征点及其连线
%   输入参数:
%       img1: 用于 montage 显示的第一张图像
%       img2: 用于 montage 显示的第二张图像
%       cleanedPoints1: 第一张图像中的匹配点坐标 (M x 2 矩阵)
%       cleanedPoints2: 第二张图像中的匹配点坐标 (M x 2 矩阵)
%       mode: 用于决定绘图样式
%   输出:
%       该函数没有显式输出参数，它会创建一个新的图形窗口并显示结果。

% 设置figure窗口的宽度和高度
figureWidth = 800;
figureHeight = 600;
hFig = figure;
% 设置figure的位置和大小 [距离屏幕左边界, 距离屏幕底部, 宽度, 高度]
set(hFig, 'Position', [100, 100, figureWidth, figureHeight]);
ax = axes;
imshowpair(img1, img2, 'montage');
hold on;

if mode == 'y'
    pstyle = 'ro';
    lstyle = 'y';
else
    pstyle = 'bo';
    lstyle = 'r';
end
% 调整点的大小和连线的粗细 第二幅图像的匹配点，加上第一幅图像的宽度偏移
for i = 1:size(cleanedPoints2, 1)
    line([cleanedPoints1(i,1), max(size(img1,2),size(img2,2)) + cleanedPoints2(i,1)],...
         [cleanedPoints1(i,2), cleanedPoints2(i,2)], 'Color', lstyle, 'LineWidth', 0.5);
end
plot(ax, cleanedPoints1(:,1), cleanedPoints1(:,2), pstyle, 'MarkerSize', 4); % 第一幅图像的匹配点
plot(ax, max(size(img1,2),size(img2,2)) + cleanedPoints2(:,1), cleanedPoints2(:,2), 'g+', 'MarkerSize', 4);
hold off;
axis off;
% 确保绘图区域填满整个figure
set(ax, 'Position', [0 0 1 1], 'Units', 'normalized');

end