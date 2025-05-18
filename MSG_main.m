clc; clear; close all; warning('off')
addpath src\

% MSG特征匹配示例

% 加载测试图像
img1 = imread('.\data\pair1-1.png');
img2 = imread('.\data\pair1-2.png');

% 设置参数
params = struct();
params.n_groups = 1;             % 尺度空间组数，2倍下采样
params.n_scales = 4;             % 每组尺度空间的层数
params.sigma = 1.6;              % 每组基础尺度
params.radius = [3,5,8,11];      % 每组滤波半径，与n_scales对应
params.iteration = [1,2,3,4];    % 每组滤波轮数，与n_scales对应

params.max_keypoints = 2000;     % 每层最大特征点数量
params.ssc_tolerance = 0.1;      % 特征点数量误差容许范围
params.edge_method = 'sobel';    % 边缘检测方式 sobel/canny
params.harris_min_quality = 0.01;% 特征点检测阈值
params.margin = 0;               % 边缘去除，默认0
params.n_hist_bins = 18;         % 主方向计算的方向直方图bin数量

params.circle_bins = 12;         % 描述符圆环的划分数量
params.log_des_hist_bins = 8;    % 描述符方向直方图bin数量
params.des_radius = 20;          % 描述符半径的比例参数，12/20/30
params.dist_ratio = 0.95;        % 最近邻比率阈值
params.error_t1 = 10;            % 初次匹配误差阈值
params.error_t2 = 3;             % 二次匹配误差阈值
params.model = 'affine';         % 变换模型 similarity/affine/perspective

t1 = clock();
% 构建多尺度空间
fprintf('构建多尺度空间...\n');
scale_space1 = multi_scale_space(img1, params);
scale_space2 = multi_scale_space(img2, params);

% 计算描述子
fprintf('计算描述子...\n');
[descriptors1, keypoints1_info] = calc_descriptors_parallel(scale_space1, params);
[descriptors2, keypoints2_info] = calc_descriptors_parallel(scale_space2, params);

% 特征匹配
fprintf('进行特征匹配...\n');
[H, keypoints1, keypoints2, match_indices] = match_two_stage(descriptors1, descriptors2, ...
    keypoints1_info(:,1:2), keypoints2_info(:,1:2), params);

t2 = clock();
time = etime(t2,t1);
fprintf('耗时: %f\n', time);

% 可视化结果
fprintf('可视化匹配结果...\n');
% figure; showMatchedFeatures(img1, img2, keypoints1, keypoints2, 'montage');
display_match(img1, img2, keypoints1, keypoints2, 'y');
fusion = image_fusion(img2, img1, H);

% 输出匹配统计信息
fprintf('匹配点对数量: %d\n', size(keypoints1,1));
