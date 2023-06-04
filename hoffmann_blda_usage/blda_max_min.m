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
%
% To modify the number of electrodes used for the calculations just select
% the amount desired in all the lines that are like ->
%
% accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:8));
%
% For reference, in that line we are using 8 channels
%% DATA FOLDERS, USER SELECTED BASED IN MAXIMUM METHOD AND STANDARD ELECTRODES

folders = ["./subject1", "./subject2", "./subject3", "./subject4", "./subject6", "./subject7", "./subject8", "./subject9"];
session = ["/s1.mat", "/s2.mat", "/s3.mat", "/s4.mat"];

channels_su1_d1_max = [1, 16, 10, 15, 12, 7, 6, 9] + 1;
channels_su2_d1_max = [2, 16, 19, 6, 12, 11, 20, 10] + 1;
channels_su3_d1_max = [0, 11, 21, 13, 8, 12, 7, 6] + 1;
channels_su4_d1_max = [5, 11, 31, 14, 18, 9, 15, 12] + 1;
channels_su6_d1_max = [26, 7, 16, 8, 31, 19, 21, 11] + 1;
channels_su7_d1_max = [17, 13, 30, 14, 12, 11, 16, 19] + 1;
channels_su8_d1_max = [4, 8, 10, 9, 11, 23, 22, 13] + 1;
channels_su9_d1_max = [7, 8, 13, 0, 12, 18, 10, 23] + 1;

channels_su1_d2_max = [1, 20, 10, 31, 13, 21, 22, 8] + 1;
channels_su2_d2_max = [13, 9, 11, 12, 15, 29, 8, 7] + 1;
channels_su3_d2_max = [11, 8, 29, 23, 17, 31, 12, 13] + 1;
channels_su4_d2_max = [25, 11, 7, 9, 20, 6, 31, 5] + 1;
channels_su6_d2_max = [31, 25, 22, 14, 19, 6, 16, 12] + 1;
channels_su7_d2_max = [26, 19, 7, 10, 8, 18, 6, 9] + 1;
channels_su8_d2_max = [25, 7, 11, 10, 13, 31, 15, 14] + 1;
channels_su9_d2_max = [23, 22, 6, 29, 11, 10, 12, 14] + 1;

channels_su1_d1_min = [24, 13, 18, 17, 21, 11, 31, 16] + 1;
channels_su2_d1_min = [28, 31, 23, 12, 21, 7, 13, 22] + 1;
channels_su3_d1_min = [4, 13, 12, 19, 21, 14, 18, 23] + 1;
channels_su4_d1_min = [28, 18, 10, 7, 8, 6, 21, 22] + 1;
channels_su6_d1_min = [10, 11, 7, 16, 13, 19, 15, 27] + 1;
channels_su7_d1_min = [18, 19, 11, 3, 17, 14, 13, 21] + 1;
channels_su8_d1_min = [14, 9, 0, 8, 18, 17, 6, 13] + 1;
channels_su9_d1_min = [16, 28, 13, 14, 9, 11, 22, 21] + 1;

channels_su1_d2_min = [15, 20, 31, 24, 12, 11, 17, 21] + 1;
channels_su2_d2_min = [7, 21, 11, 3, 18, 14, 12, 15] + 1;
channels_su3_d2_min = [6, 7, 25, 21, 31, 12, 23, 17] + 1;
channels_su4_d2_min = [18, 23, 27, 7, 15, 17, 20, 16] + 1;
channels_su6_d2_min = [12, 19, 8, 21, 16, 1, 18, 14] + 1;
channels_su7_d2_min = [3, 14, 19, 15, 22, 17, 21, 18] + 1;
channels_su8_d2_min = [16, 11, 17, 13, 0, 14, 19, 9] + 1;
channels_su9_d2_min = [27, 6, 23, 15, 12, 13, 11, 8] + 1;

standard_electrodes = [12, 31, 30, 15, 10, 11, 18, 19] + 1;

channels_d1_max = {channels_su1_d1_max, channels_su2_d1_max, channels_su3_d1_max, channels_su4_d1_max, channels_su6_d1_max, channels_su7_d1_max, channels_su8_d1_max, channels_su9_d1_max};
channels_d2_max = {channels_su1_d2_max, channels_su2_d2_max, channels_su3_d2_max, channels_su4_d2_max, channels_su6_d2_max, channels_su7_d2_max, channels_su8_d2_max, channels_su9_d2_max};

channels_d1_min = {channels_su1_d1_min, channels_su2_d1_min, channels_su3_d1_min, channels_su4_d1_min, channels_su6_d1_min, channels_su7_d1_min, channels_su8_d1_min, channels_su9_d1_min};
channels_d2_min = {channels_su1_d2_min, channels_su2_d2_min, channels_su3_d2_min, channels_su4_d2_min, channels_su6_d2_min, channels_su7_d2_min, channels_su8_d2_min, channels_su9_d2_min};

%% PLOTTING SELECTED VS STANDARD AVERAGED BY USERS AND BY DAYS

final_acurracy_per_max = zeros(1,20);
final_acurracy_per_min = zeros(1,20);
final_acurracy_std = zeros(1,20);

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
    
    
    final_acurracy_per_max = final_acurracy_per_max + accuracy_d1_per_max + accuracy_d2_per_max;
    final_acurracy_per_min = final_acurracy_per_min + accuracy_d1_per_min + accuracy_d2_per_min;
    final_acurracy_std = final_acurracy_std + accuracy_d1_std + accuracy_d2_std;
    
end

final_acurracy_per_max = final_acurracy_per_max / 16;
final_acurracy_per_min = final_acurracy_per_min / 16;
final_acurracy_std = final_acurracy_std / 16;

x = 1:20;

hold on
plot(x,final_acurracy_per_max,'o-b','MarkerSize',7);
plot(x,final_acurracy_per_min,'s-r','MarkerSize',7);
plot(x,final_acurracy_std,'*-k','MarkerSize',7);
hold off

set(gca,'ylim',[40 100]);
%set(gca,'ytick',0:10:100);
%set(gca,'ytick',0:10:100);
set(gca, 'XLim', [1 20])
xlabel('trials');
ylabel('Accuracy (%)');grid on;

legend('Max','Min','Std');
title('Accuracy 8 electrodes');
%% PLOTTING SELECTED VS STANDARD SEPARATING DAYS AND USERS

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    figure

    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:8));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:8));

    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:8));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:8));

    x = 1:20;

    hold on
    plot(x,accuracy_d1_per,'o-b','MarkerSize',7);
    plot(x,accuracy_d1_std,'o-r','MarkerSize',7);
    plot(x,accuracy_d2_per,'*-b','MarkerSize',7);
    plot(x,accuracy_d2_std,'*-r','MarkerSize',7);
    hold off

    set(gca,'ylim',[0 100]);
    set(gca,'ytick',0:10:100);
    set(gca,'ytick',0:10:100);
    set(gca, 'XLim', [1 20])
    xlabel('trials');
    ylabel('Accuracy (%)');grid on;

    legend('Per chnnl d1','Std chnnl d1','Per chnnl d2', 'Std chnnl d2')
    
    title(['Subject ' s1{1}(10) ' Eight channels'] );
end

%% PLOTTING SELECTED VS STANDARD AVERAGED BY DAYS SEPARATED BY USER
for i = 1:length(folders)
    
    final_acurracy_per = zeros(1,20);
    final_acurracy_std = zeros(1,20);

    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    figure

    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:8));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:8));
    
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:8));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:8));
    
    final_acurracy_per = final_acurracy_per + accuracy_d1_per + accuracy_d2_per;
    final_acurracy_std = final_acurracy_std + accuracy_d1_std + accuracy_d2_std;
    
    final_acurracy_per = final_acurracy_per / 2;
    final_acurracy_std = final_acurracy_std / 2;
    
    x = 1:20;

    hold on
    plot(x,final_acurracy_per,'o-b','MarkerSize',7);
    plot(x,final_acurracy_std,'o-r','MarkerSize',7);
    hold off
    
    set(gca,'ylim',[0 100]);
    set(gca,'ytick',0:10:100);
    set(gca,'ytick',0:10:100);
    set(gca, 'XLim', [1 20])
    xlabel('trials');
    ylabel('Accuracy (%)');grid on;

    legend('Per chnnl','Std chnnl')
    
    title(['Subject ' s1{1}(10) ' Eight channels']);
end
%% PLOTTING SELECTED VS STANDARD AVERAGED BY USERS SEPARATED BY DAYS

final_acurracy_per_1 = zeros(1,20);
final_acurracy_std_1 = zeros(1,20);

final_acurracy_per_2 = zeros(1,20);
final_acurracy_std_2 = zeros(1,20);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};
    
    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:8));
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:8));
    
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:8));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:8));
    
    final_acurracy_per_1 = final_acurracy_per_1 + accuracy_d1_per;
    final_acurracy_std_1 = final_acurracy_std_1 + accuracy_d1_std;
    
    final_acurracy_per_2 = final_acurracy_per_2 + accuracy_d2_per;
    final_acurracy_std_2 = final_acurracy_std_2 + accuracy_d2_std;
end

final_acurracy_per_1 = final_acurracy_per_1 / 8;
final_acurracy_std_1 = final_acurracy_std_1 / 8;

final_acurracy_per_2 = final_acurracy_per_2 / 8;
final_acurracy_std_2 = final_acurracy_std_2 / 8;

x = 1:20;

hold on
plot(x,final_acurracy_per_1,'o-b','MarkerSize',7);
plot(x,final_acurracy_std_1,'o-r','MarkerSize',7);
plot(x,final_acurracy_per_2,'*-b','MarkerSize',7);
plot(x,final_acurracy_std_2,'*-r','MarkerSize',7);
hold off

set(gca,'ylim',[0 100]);
set(gca,'ytick',0:10:100);
set(gca,'ytick',0:10:100);
set(gca, 'XLim', [1 20])
xlabel('trials');
ylabel('Accuracy (%)');grid on;

legend('Per chnnl d1','Std chnnl d1','Per chnnl d2', 'Std chnnl d2')
title('Accuracy of all users for eight channels');

