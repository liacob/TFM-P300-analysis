close all
clear all
clc

%% DISCLAIMER

% In this script we use the set of electrodes that we selected via
% the Bayesian method proposed in "Techniques for temporal detection of 
% neural sensitivity to external stimulation" by Francisco Rodríguez in 
% conjuntion with the BLDA technique developed by Ulrich Hoffman.
%
% To be able to use the crossvalidate funtion you have to download his
% public software available in "An efficient P300-based brain–computer 
% interface for disabled subjects".
% 
% Link https://www.sciencedirect.com/science/article/pii/S0165027007001094
%% DATA FOLDERS, USER SELECTED BASED IN MAXIMUM METHOD AND STANDARD ELECTRODES

folders = ["./subject1", "./subject2", "./subject3", "./subject4", "./subject6", "./subject7", "./subject8", "./subject9"];
session = ["/s1.mat", "/s2.mat", "/s3.mat", "/s4.mat"];

channels_su1_d1_max = [1, 29, 0, 16, 2, 3, 10, 5] + 1;
channels_su2_d1_max = [2, 16, 19, 6, 29, 0, 1, 27] + 1;
channels_su3_d1_max = [0, 30, 3, 11, 21, 13, 1, 8] + 1;
channels_su4_d1_max = [5, 11, 25, 31, 1, 3, 22, 28] + 1;
channels_su6_d1_max = [26, 29, 25, 7, 24, 16, 8, 4] + 1;
channels_su7_d1_max = [17, 13, 30, 26, 29, 4, 14, 12] + 1;
channels_su8_d1_max = [4, 8, 25, 0, 28, 3, 10, 30] + 1;
channels_su9_d1_max = [7, 8, 13, 0, 12, 18, 10, 27] + 1;

channels_su1_d2_max = [1, 0, 28, 20, 5, 10, 2, 29] + 1;
channels_su2_d2_max = [13, 9, 11, 12, 15, 29, 8, 7] + 1;
channels_su3_d2_max = [11, 8, 29, 30, 23, 25, 27, 17] + 1;
channels_su4_d2_max = [25, 1, 11, 30, 7, 3, 9, 29] + 1;
channels_su6_d2_max = [31, 25, 22, 14, 19, 5, 6, 16] + 1;
channels_su7_d2_max = [26, 19, 25, 7, 10, 4, 3, 8] + 1;
channels_su8_d2_max = [25, 29, 0, 7, 30, 11, 10, 13] + 1;
channels_su9_d2_max = [23, 22, 6, 29, 11, 2, 10, 24] + 1;

channels_su1_d1_min = [24, 1, 13, 18, 0, 17, 25, 21] + 1;
channels_su2_d1_min = [28, 24, 31, 23, 0, 12, 21, 4] + 1;
channels_su3_d1_min = [4, 30, 13, 12, 24, 19, 21, 14] + 1;
channels_su4_d1_min = [28, 18, 10, 7, 8, 26, 6, 27] + 1;
channels_su6_d1_min = [10, 11, 7, 16, 13, 19, 15, 27] + 1;
channels_su7_d1_min = [18, 19, 11, 3, 17, 14, 13, 21] + 1;
channels_su8_d1_min = [14, 9, 0, 30, 8, 18, 26, 17] + 1;
channels_su9_d1_min = [16, 28, 13, 14, 9, 24, 11, 29] + 1;

channels_su1_d2_min = [15, 20, 31, 24, 27, 12, 11, 17] + 1;
channels_su2_d2_min = [7, 21, 11, 3, 18, 14, 12, 15] + 1;
channels_su3_d2_min = [6, 7, 25, 30, 21, 26, 4, 31] + 1;
channels_su4_d2_min = [18, 23, 27, 0, 1, 4, 7, 15] + 1;
channels_su6_d2_min = [12, 19, 8, 21, 16, 1, 18, 14] + 1;
channels_su7_d2_min = [3, 14, 19, 15, 22, 17, 21, 18] + 1;
channels_su8_d2_min = [16, 11, 17, 13, 0, 29, 2, 14] + 1;
channels_su9_d2_min = [27, 26, 6, 0, 23, 15, 12, 13] + 1;

standard_electrodes = [12, 31, 30, 15, 10, 11, 18, 19] + 1;

channels_d1_max = {channels_su1_d1_max, channels_su2_d1_max, channels_su3_d1_max, channels_su4_d1_max, channels_su6_d1_max, channels_su7_d1_max, channels_su8_d1_max, channels_su9_d1_max};
channels_d2_max = {channels_su1_d2_max, channels_su2_d2_max, channels_su3_d2_max, channels_su4_d2_max, channels_su6_d2_max, channels_su7_d2_max, channels_su8_d2_max, channels_su9_d2_max};

channels_d1_min = {channels_su1_d1_min, channels_su2_d1_min, channels_su3_d1_min, channels_su4_d1_min, channels_su6_d1_min, channels_su7_d1_min, channels_su8_d1_min, channels_su9_d1_min};
channels_d2_min = {channels_su1_d2_min, channels_su2_d2_min, channels_su3_d2_min, channels_su4_d2_min, channels_su6_d2_min, channels_su7_d2_min, channels_su8_d2_min, channels_su9_d2_min};
%% 1 ch

final_acc_per_max_d1_1ch = zeros(1,8);
final_acc_per_min_d1_1ch = zeros(1,8);
final_acc_std_d1_1ch = zeros(1,8);

final_acc_per_max_d2_1ch = zeros(1,8);
final_acc_per_min_d2_1ch = zeros(1,8);
final_acc_std_d2_1ch = zeros(1,8);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    accuracy_d1_per_max = crossvalidate(filelist_d1, channels_d1_max{i}(1:1));
    accuracy_d1_per_min = crossvalidate(filelist_d1, channels_d1_min{i}(1:1));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:1));

    accuracy_d2_per_max = crossvalidate(filelist_d2, channels_d2_max{i}(1:1));
    accuracy_d2_per_min = crossvalidate(filelist_d2, channels_d2_min{i}(1:1));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:1));
    
    final_acc_per_max_d1_1ch(i) = accuracy_d1_per_max(20);
    final_acc_per_min_d1_1ch(i) = accuracy_d1_per_min(20);
    final_acc_std_d1_1ch(i) = accuracy_d1_std(20);
    
    final_acc_per_max_d2_1ch(i) = accuracy_d2_per_max(20);
    final_acc_per_min_d2_1ch(i) = accuracy_d2_per_min(20);
    final_acc_std_d2_1ch(i) = accuracy_d2_std(20);

end
%% 2 ch

final_acc_per_max_d1_2ch = zeros(1,8);
final_acc_per_min_d1_2ch = zeros(1,8);
final_acc_std_d1_2ch = zeros(1,8);

final_acc_per_max_d2_2ch = zeros(1,8);
final_acc_per_min_d2_2ch = zeros(1,8);
final_acc_std_d2_2ch = zeros(1,8);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    accuracy_d1_per_max = crossvalidate(filelist_d1, channels_d1_max{i}(1:2));
    accuracy_d1_per_min = crossvalidate(filelist_d1, channels_d1_min{i}(1:2));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:2));

    accuracy_d2_per_max = crossvalidate(filelist_d2, channels_d2_max{i}(1:2));
    accuracy_d2_per_min = crossvalidate(filelist_d2, channels_d2_min{i}(1:2));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:2));
    
    final_acc_per_max_d1_2ch(i) = accuracy_d1_per_max(20);
    final_acc_per_min_d1_2ch(i) = accuracy_d1_per_min(20);
    final_acc_std_d1_2ch(i) = accuracy_d1_std(20);
    
    final_acc_per_max_d2_2ch(i) = accuracy_d2_per_max(20);
    final_acc_per_min_d2_2ch(i) = accuracy_d2_per_min(20);
    final_acc_std_d2_2ch(i) = accuracy_d2_std(20);

end
%% 3 ch

final_acc_per_max_d1_3ch = zeros(1,8);
final_acc_per_min_d1_3ch = zeros(1,8);
final_acc_std_d1_3ch = zeros(1,8);

final_acc_per_max_d2_3ch = zeros(1,8);
final_acc_per_min_d2_3ch = zeros(1,8);
final_acc_std_d2_3ch = zeros(1,8);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    accuracy_d1_per_max = crossvalidate(filelist_d1, channels_d1_max{i}(1:3));
    accuracy_d1_per_min = crossvalidate(filelist_d1, channels_d1_min{i}(1:3));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:3));

    accuracy_d2_per_max = crossvalidate(filelist_d2, channels_d2_max{i}(1:3));
    accuracy_d2_per_min = crossvalidate(filelist_d2, channels_d2_min{i}(1:3));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:3));
    
    final_acc_per_max_d1_3ch(i) = accuracy_d1_per_max(20);
    final_acc_per_min_d1_3ch(i) = accuracy_d1_per_min(20);
    final_acc_std_d1_3ch(i) = accuracy_d1_std(20);
    
    final_acc_per_max_d2_3ch(i) = accuracy_d2_per_max(20);
    final_acc_per_min_d2_3ch(i) = accuracy_d2_per_min(20);
    final_acc_std_d2_3ch(i) = accuracy_d2_std(20);

end
%% 4 ch

final_acc_per_max_d1_4ch = zeros(1,8);
final_acc_per_min_d1_4ch = zeros(1,8);
final_acc_std_d1_4ch = zeros(1,8);

final_acc_per_max_d2_4ch = zeros(1,8);
final_acc_per_min_d2_4ch = zeros(1,8);
final_acc_std_d2_4ch = zeros(1,8);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    accuracy_d1_per_max = crossvalidate(filelist_d1, channels_d1_max{i}(1:4));
    accuracy_d1_per_min = crossvalidate(filelist_d1, channels_d1_min{i}(1:4));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:4));

    accuracy_d2_per_max = crossvalidate(filelist_d2, channels_d2_max{i}(1:4));
    accuracy_d2_per_min = crossvalidate(filelist_d2, channels_d2_min{i}(1:4));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:4));
    
    final_acc_per_max_d1_4ch(i) = accuracy_d1_per_max(20);
    final_acc_per_min_d1_4ch(i) = accuracy_d1_per_min(20);
    final_acc_std_d1_4ch(i) = accuracy_d1_std(20);
    
    final_acc_per_max_d2_4ch(i) = accuracy_d2_per_max(20);
    final_acc_per_min_d2_4ch(i) = accuracy_d2_per_min(20);
    final_acc_std_d2_4ch(i) = accuracy_d2_std(20);

end
%% 8 ch

final_acc_per_max_d1_8ch = zeros(1,8);
final_acc_per_min_d1_8ch = zeros(1,8);
final_acc_std_d1_8ch = zeros(1,8);

final_acc_per_max_d2_8ch = zeros(1,8);
final_acc_per_min_d2_8ch = zeros(1,8);
final_acc_std_d2_8ch = zeros(1,8);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    accuracy_d1_per_max = crossvalidate(filelist_d1, channels_d1_max{i}(1:8));
    accuracy_d1_per_min = crossvalidate(filelist_d1, channels_d1_min{i}(1:8));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:8));

    accuracy_d2_per_max = crossvalidate(filelist_d2, channels_d2_max{i}(1:8));
    accuracy_d2_per_min = crossvalidate(filelist_d2, channels_d2_min{i}(1:8));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:8));
    
    final_acc_per_max_d1_8ch(i) = accuracy_d1_per_max(20);
    final_acc_per_min_d1_8ch(i) = accuracy_d1_per_min(20);
    final_acc_std_d1_8ch(i) = accuracy_d1_std(20);
    
    final_acc_per_max_d2_8ch(i) = accuracy_d2_per_max(20);
    final_acc_per_min_d2_8ch(i) = accuracy_d2_per_min(20);
    final_acc_std_d2_8ch(i) = accuracy_d2_std(20);
    
end 

%% STACKED BARPLOTS MAX D1

per = zeros(1,5);
eq = zeros(1,5);
std = zeros(1,5);

final_acc_per_d1 = vertcat(final_acc_per_max_d1_1ch, final_acc_per_max_d1_2ch, final_acc_per_max_d1_3ch, final_acc_per_max_d1_4ch, final_acc_per_max_d1_8ch);
final_acc_std_d1 = vertcat(final_acc_std_d1_1ch, final_acc_std_d1_2ch, final_acc_std_d1_3ch, final_acc_std_d1_4ch, final_acc_std_d1_8ch);

for i = 1:5
    
    per(i) = sum(final_acc_per_d1(i,1:8) > final_acc_std_d1(i,1:8));
    eq(i) = sum(final_acc_per_d1(i,1:8) == final_acc_std_d1(i,1:8));
    std(i) = 8 - per(i) - eq(i);

end

X = categorical({'1', '2', '3', '4', '8'});
Y = [per;eq;std];

bar_width = 0.8;

figure;
bar(X, Y, bar_width, 'stacked');

xlabel('Nº of electrodes');
ylabel('Users');
title('Max vs Std method day 1');
legend('Max', 'Tie', 'Std');

%% STACKED BARPLOTS MAX D2

per = zeros(1,5);
eq = zeros(1,5);
std = zeros(1,5);

final_acc_per_d2 = vertcat(final_acc_per_max_d2_1ch, final_acc_per_max_d2_2ch, final_acc_per_max_d2_3ch, final_acc_per_max_d2_4ch, final_acc_per_max_d2_8ch);
final_acc_std_d2 = vertcat(final_acc_std_d2_1ch, final_acc_std_d2_2ch, final_acc_std_d2_3ch, final_acc_std_d2_4ch, final_acc_std_d2_8ch);

for i = 1:5
    
    per(i) = sum(final_acc_per_d2(i,1:8) > final_acc_std_d2(i,1:8));
    eq(i) = sum(final_acc_per_d2(i,1:8) == final_acc_std_d2(i,1:8));
    std(i) = 8 - per(i) - eq(i);

end

X = categorical({'1', '2', '3', '4', '8'});
Y = [per;eq;std];

bar_width = 0.8;

figure;
bar(X, Y, bar_width, 'stacked');

xlabel('Nº of electrodes');
ylabel('Users');
title('Max vs Std method day 2');
legend('Max', 'Tie', 'Std');

%% STACKED BARPLOTS MIN D1

per = zeros(1,5);
eq = zeros(1,5);
std = zeros(1,5);

final_acc_per_d1 = vertcat(final_acc_per_min_d1_1ch, final_acc_per_min_d1_2ch, final_acc_per_min_d1_3ch, final_acc_per_min_d1_4ch, final_acc_per_min_d1_8ch);
final_acc_std_d1 = vertcat(final_acc_std_d1_1ch, final_acc_std_d1_2ch, final_acc_std_d1_3ch, final_acc_std_d1_4ch, final_acc_std_d1_8ch);

for i = 1:5
    
    per(i) = sum(final_acc_per_d1(i,1:8) > final_acc_std_d1(i,1:8));
    eq(i) = sum(final_acc_per_d1(i,1:8) == final_acc_std_d1(i,1:8));
    std(i) = 8 - per(i) - eq(i);

end

X = categorical({'1', '2', '3', '4', '8'});
Y = [per;eq;std];

bar_width = 0.8;

figure;
bar(X, Y, bar_width, 'stacked');

xlabel('Nº of electrodes');
ylabel('Users');
title('Min vs Std method day 1');
legend('Min', 'Tie', 'Std');

%% STACKED BARPLOTS MIN D2

per = zeros(1,5);
eq = zeros(1,5);
std = zeros(1,5);

final_acc_per_d2 = vertcat(final_acc_per_min_d2_1ch, final_acc_per_min_d2_2ch, final_acc_per_min_d2_3ch, final_acc_per_min_d2_4ch, final_acc_per_min_d2_8ch);
final_acc_std_d2 = vertcat(final_acc_std_d2_1ch, final_acc_std_d2_2ch, final_acc_std_d2_3ch, final_acc_std_d2_4ch, final_acc_std_d2_8ch);

for i = 1:5
    
    per(i) = sum(final_acc_per_d2(i,1:8) > final_acc_std_d2(i,1:8));
    eq(i) = sum(final_acc_per_d2(i,1:8) == final_acc_std_d2(i,1:8));
    std(i) = 8 - per(i) - eq(i);

end

X = categorical({'1', '2', '3', '4', '8'});
Y = [per;eq;std];

bar_width = 0.8;

figure;
bar(X, Y, bar_width, 'stacked');

xlabel('Nº of electrodes');
ylabel('Users');
title('Min vs Std method day 2');
legend('Min', 'Tie', 'Std');

%% BARPLOT PER USER

X = categorical({'1', '2', '3', '4','6','7','8','9'});

CHANNELS = {'one','two','three','four','eight'};
WORD = {'channel','channels','channels','channels','channels'};
TITLES = {'Max vs Std one channel day 1', 'Max vs Std two channels day 1', 'Max vs Std three channels day 1', 'Max vs Std four channels day 1', 'Max vs Std eight channels day 1'};

final_acc_per_d1 = vertcat(final_acc_per_max_d1_1ch, final_acc_per_max_d1_2ch, final_acc_per_max_d1_3ch, final_acc_per_max_d1_4ch, final_acc_per_max_d1_8ch);
final_acc_std_d1 = vertcat(final_acc_std_d1_1ch, final_acc_std_d1_2ch, final_acc_std_d1_3ch, final_acc_std_d1_4ch, final_acc_std_d1_8ch);

t = tiledlayout(5,1);
t.Padding = 'compact';
t.TileSpacing = 'compact';
for i = 1:5
    
Y1 = final_acc_per_d1(i,1:8);
Y2 = final_acc_std_d1(i,1:8);

nexttile
bar(X, [Y1', Y2'], 'grouped');

xlabel('User');
ylabel('Accuracy');
title(TITLES(i));
legend('Max', 'Std');

end
