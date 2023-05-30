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

channels_su1_d1 = [1, 29, 0, 16, 2, 3, 10, 5] + 1;
channels_su2_d1 = [2, 16, 19, 6, 29, 0, 1, 27] + 1;
channels_su3_d1 = [0, 30, 3, 11, 21, 13, 1, 8] + 1;
channels_su4_d1 = [5, 11, 25, 31, 1, 3, 22, 28] + 1;
channels_su6_d1 = [26, 29, 25, 7, 24, 16, 8, 4] + 1;
channels_su7_d1 = [17, 13, 30, 26, 29, 4, 14, 12] + 1;
channels_su8_d1 = [4, 8, 25, 0, 28, 3, 10, 30] + 1;
channels_su9_d1 = [7, 8, 13, 0, 12, 18, 10, 27] + 1;

channels_su1_d2 = [1, 0, 28, 20, 5, 10, 2, 29] + 1;
channels_su2_d2 = [13, 9, 11, 12, 15, 29, 8, 7] + 1;
channels_su3_d2 = [11, 8, 29, 30, 23, 25, 27, 17] + 1;
channels_su4_d2 = [25, 1, 11, 30, 7, 3, 9, 29] + 1;
channels_su6_d2 = [31, 25, 22, 14, 19, 5, 6, 16] + 1;
channels_su7_d2 = [26, 19, 25, 7, 10, 4, 3, 8] + 1;
channels_su8_d2 = [25, 29, 0, 7, 30, 11, 10, 13] + 1;
channels_su9_d2 = [23, 22, 6, 29, 11, 2, 10, 24] + 1;
 
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
    
    accuracy_d1_per = crossvalidate(filelist_d1, channels_d1{i}(1:8));
    accuracy_d2_per = crossvalidate(filelist_d2, channels_d2{i}(1:8));
    
    accuracy_d1_std = crossvalidate(filelist_d1, standard_electrodes(1:8));
    accuracy_d2_std = crossvalidate(filelist_d2, standard_electrodes(1:8));
    
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
title('Accuracy of all users for eight channels');