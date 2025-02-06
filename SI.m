clc
clear
close all

% Calculation of the SI for all the configurations

MERGED=xlsread('MERGED_KE_HY.xlsx');

td_norm=zeros(length(MERGED), 1);  
eig_norm=zeros(length(MERGED), 1);
stress_norm=zeros(length(MERGED), 1);
perf=zeros(length(MERGED), 1);
e_norm=zeros(length(MERGED), 1);
c_norm=zeros(length(MERGED), 1);
S_I=zeros(length(MERGED), 1);
config=zeros(length(MERGED), 1);

% Min Max Normalization


td_max=max(MERGED(:,5));
td_min=min(MERGED(:,5));

eig_max=max(MERGED(:,6));
eig_min=min(MERGED(:,6));

e_max=max(MERGED(:,8));
e_min=min(MERGED(:,8));

c_max=max(MERGED(:,7));
c_min=min(MERGED(:,7));



for i=1:length(MERGED)

    td_norm(i)=1-(MERGED(i,5)-td_min)/(td_max-td_min);
    eig_norm(i)=(MERGED(i,6)-eig_min)/(eig_max-eig_min);

    perf(i)=0.5.*td_norm(i)+0.5.*eig_norm(i);     % Performance Pillar (Normalized)

    c_norm(i)=1-(MERGED(i,7)-c_min)/(c_max-c_min);
    e_norm(i)=1-(MERGED(i,8)-e_min)/(e_max-e_min);

    S_I(i)=0.09.*perf(i)+0.09.*c_norm(i)+0.64.*e_norm(i)+0.09.*MERGED(i,9)+0.09.*MERGED(i,10);  % Sustainability Index

   config(i)=i;
end


SI_points=[config,MERGED(:,1:3),MERGED(:,11:12), perf,c_norm,e_norm,MERGED(:,9:10),S_I];

[~, sort_order] = sort(SI_points(:, 12), 'descend');       % SI Ranking of the configurations
sorted_matrix = SI_points(sort_order, :);

writematrix(sorted_matrix,'Ranking-env-KER-HYD_v2.xlsx')
