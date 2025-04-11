clc
clear
close all



%% load BOLD components
data_loc  = '/bif/storage/storage3/projects/apicde/LolaRennt/Process_tfeng/';
load subject_list.mat
sub_folders = subjects_list;
acc_TC = zeros(0,1210);

for num_sub = 1:length(sub_folders)
    current_dir = strcat(data_loc,sub_folders{num_sub});
    TE_mode = load(fullfile(current_dir,'tensor_ICA','tica_s4r03','melodic_Smodes')); 
    Time_course = load(fullfile(current_dir,'tensor_ICA','tica_s4r03','melodic_Tmodes'));
    Time_course = Time_course(:,1:5:end);
    num_comps = size(TE_mode,2);
    num_voxels = size(Time_course,1);
    acc_comp = [];
    for i = 1:num_comps
        p = polyfit([12.7,28.6,43.5,57.4],TE_mode(:,i),2);
        if -p(2)/(2*p(1))>20&-p(2)/(2*p(1))<50
            acc_cmp(end+1,1) = i;
        end
    end
    acc_TC(end+1:end+length(acc_comp),:) = Time_course(:,acc_comp)';
    acc_TE{num_sub,1} = TE_mode(:,acc_comp);
    num_acc2(num_sub) = length(acc_comp);
end
%% temporal ica
comp = 15;
runs = 20;
data_ICA = acc_TC';

fprintf('\n Performing variance normalization ...');
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
for n = 1:size(data_ICA, 2)
data_ICA(:, n) = filter(b,a,data_ICA(:, n));
data_ICA(:, n) = detrend(data_ICA(:, n), 0) ./ std(data_ICA(:, n));
end
    
[coeff,score,latent,tsquared,explained,mu] = pca(data_ICA);
[~,kurt_ind]=sort(zscore(kurtosis(score).*latent'),'descend');
% data_ICA = score(:,1:20);
X=score(:,1:comp)';
[sR,step]=icassoEst_infomaxICA('both',X ,runs, 'lastEig', comp, 'g', 'tanh', ...
                'approach', 'symm');

sR=icassoExp(sR);
[iq,A,W,S] = icassoShow(sR,'L',comp,'colorlimit',[.8 .9]);

