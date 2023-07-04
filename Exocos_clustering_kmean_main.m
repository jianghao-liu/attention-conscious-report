clear all
close all
addpath utils

code_path = 'E:\ICM\exocos_Jh\TrajectoryKmean';
cd(code_path)
load('HFBB_allpp_Elec_time_cond.mat')

%%
n_dim=8; %number of conditions / dimensions to cluster
allp_mean_env = Elec_time_cond;
%%%% normalization
me = mean(allp_mean_env(:,:),2);
st = std(allp_mean_env(:,:),[],2);


for j = 1:size(allp_mean_env,1)
    
    for i = 1:size(allp_mean_env,3)
        
       allp_mean_env(j,:,i) = (allp_mean_env(j,:,i) - me(j))/st(j);     
        
    end
    
end

%%
%%% clustering 
id_all = {};
clust_all = {};
parfor n_clust = 2:12

    tic
    [id,clust] = traj_kmeans(permute(allp_mean_env,[3 2 1]),n_clust,500); % channel * time * cond -> cond(dim)* time * channel

    toc
    figure
    for i = 1:n_clust
        n_el = sum(id==i);
        for j = 1:n_dim
            subplot(n_dim,n_clust,i+j*n_clust -n_clust)
            plot(clust(j,:,i))
            if j==1
                title(['n electrodes:' num2str(n_el)])
            end
            if i == 1
                switch j 
                    case 1
                        ylabel('Ip-V-S')
                    case 2
                        ylabel('Ip-V-Us')
                    case 3
                        ylabel('Ip-Iv-S')
                    case 4
                        ylabel('Ip-Iv-Us')
                    case 5
                        ylabel('C-V-S')
                    case 6
                        ylabel('C-V-Us')
                    case 7
                        ylabel('C-Iv-S')
                    case 8
                        ylabel('C-Iv-Us')
                end
            end
          axis([0 180 -1 2])  
        end
    end
    savefig([num2str(i) ' Clusters'])

    id_all{n_clust -1} = id;
    clust_all{n_clust -1} = clust;
end

save('results_trmean_clust.mat', 'id_all', 'clust_all')