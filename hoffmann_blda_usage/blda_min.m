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
%% DATA FOLDERS, USER SELECTED BASED IN MINIMUM METHOD AND STANDARD ELECTRODES

folders = ["./subject1", "./subject2", "./subject3", "./subject4", "./subject6", "./subject7", "./subject8", "./subject9"];
session = ["/s1.mat", "/s2.mat", "/s3.mat", "/s4.mat"];

channels_su1_d1 = [24, 1, 13, 18, 0, 17, 25, 21] + 1;
channels_su2_d1 = [28, 24, 31, 23, 0, 12, 21, 4] + 1;
channels_su3_d1 = [4, 30, 13, 12, 24, 19, 21, 14] + 1;
channels_su4_d1 = [28, 18, 10, 7, 8, 26, 6, 27] + 1;
channels_su6_d1 = [10, 11, 7, 16, 13, 19, 15, 27] + 1;
channels_su7_d1 = [18, 19, 11, 3, 17, 14, 13, 21] + 1;
channels_su8_d1 = [14, 9, 0, 30, 8, 18, 26, 17] + 1;
channels_su9_d1 = [16, 28, 13, 14, 9, 24, 11, 29] + 1;

channels_su1_d2 = [15, 20, 31, 24, 27, 12, 11, 17] + 1;
channels_su2_d2 = [7, 21, 11, 3, 18, 14, 12, 15] + 1;
channels_su3_d2 = [6, 7, 25, 30, 21, 26, 4, 31] + 1;
channels_su4_d2 = [18, 23, 27, 0, 1, 4, 7, 15] + 1;
channels_su6_d2 = [12, 19, 8, 21, 16, 1, 18, 14] + 1;
channels_su7_d2 = [3, 14, 19, 15, 22, 17, 21, 18] + 1;
channels_su8_d2 = [16, 11, 17, 13, 0, 29, 2, 14] + 1;
channels_su9_d2 = [27, 26, 6, 0, 23, 15, 12, 13] + 1;
 
standard_electrodes = [12, 31, 30, 15, 10, 11, 18, 19] + 1;
channels_d1 = {channels_su1_d1, channels_su2_d1, channels_su3_d1, channels_su4_d1, channels_su6_d1, channels_su7_d1, channels_su8_d1, channels_su9_d1};
channels_d2 = {channels_su1_d2, channels_su2_d2, channels_su3_d2, channels_su4_d2, channels_su6_d2, channels_su7_d2, channels_su8_d2, channels_su9_d2};

%% PLOTTING SELECTED VS STANDARD SEPARATING DAYS AND USERS

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};

    figure

    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:1));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:1));

    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:1));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:1));

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
    
    title(['Subject ' s1{1}(10) ' One channel'] );
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

    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:1));
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:1));
    
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:1));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:1));
    
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
    
    title(['Subject ' s1{1}(10) ' One channel']);
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
    
    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:1));
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:1));
    
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:1));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:1));
    
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
title('Accuracy of all users for one channel');

%% PLOTTING SELECTED VS STANDARD AVERAGED BY USERS AND BY DAYS

final_acurracy_per = zeros(1,20);
final_acurracy_std = zeros(1,20);

for i = 1:length(folders)
    
    s1 = strcat(folders(i),session(1));
    s2 = strcat(folders(i),session(2));
    s3 = strcat(folders(i),session(3));
    s4 = strcat(folders(i),session(4));

    filelist_d1 = {s1,s2};
    filelist_d2 = {s3,s4};
    
    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:1));
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:1));
    
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:1));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:1));
    
    final_acurracy_per = final_acurracy_per + accuracy_d1_per + accuracy_d2_per;
    final_acurracy_std = final_acurracy_std + accuracy_d1_std + accuracy_d2_std;
    
end

final_acurracy_per = final_acurracy_per / 16;
final_acurracy_std = final_acurracy_std / 16;

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

legend('Per chnnl','Std chnnl');
title('Accuracy of all users for one channel');