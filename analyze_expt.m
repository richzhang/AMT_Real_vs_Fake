function [] = analyze_expt(expt_name)

	%% expt parameters
	opt = getOpts(expt_name);

	%% check parameters
	checkOpts(opt);
	
	%%
	rng('shuffle');

	%%
	results_file = fullfile(opt.expt_name,sprintf('res_2.xlsx'));
	
	%%
	a = readtable(results_file);
	a = [a.Properties.VariableNames;table2cell(a)];
	header = a(1,:);
	
	
	    
	%% filter out gt_sides and answers
	gt_side = {};
	answer = {};
	
	Nhits = size(a,1)-1;
% 	Npairs = 50;%opt.Npairs;
	Npairs = opt.Npairs;
	for j=1:Nhits
	    
	    for i=1:Npairs
	        
	        row = j+1;
	        
	        col = find(strcmp(header,sprintf('Input_gt_side%d',i)));
	        gt_side{j,i} = a(row,col);
	        
	        col = find(strcmp(header,sprintf('Answer_selection%d',i)));
	        answer{j,i} = a(row,col);
	    end
	end
	
	%% analyze
	Npractice = opt.Npractice;
	Nreal = Npairs-Npractice;
	num_correct_per_subj = zeros(Nhits,1);
	for j=1:Nhits
	    for i=(Npractice+1):Npairs
	        num_correct_per_subj(j) = num_correct_per_subj(j)+(~strcmp(gt_side{j,i},answer{j,i}));
	    end
	end
	percent_correct = num_correct_per_subj/Nreal;
	hist(1-percent_correct); title(sprintf('percent of time Turkers chose fake over real\nmean = %1.2f',mean(1-percent_correct)));
	
	
	
	%% compare algorithms
	which_algs = opt.which_algs_paths;
	Nimgs = opt.Nimgs; val_inds = 1:Nimgs;
	percent_correct_per_img = [];
	num_correct_per_img = zeros(length(which_algs),Nimgs);
	total_trials_per_img = zeros(length(which_algs),Nimgs);
	for j=1:length(which_algs)
	    for i=1:Nimgs
	        [ii,jj] = ind2sub(size(a),find(strcmp(a,sprintf('%s/%d',which_algs{j},val_inds(i)))));
	        ii=ii-1; % removes header
	        for k=1:length(ii)
	            tmp = a{1,jj(k)};
	            tmp2 = regexp(tmp,'\d');
	            trial_num = str2double(tmp(tmp2(1):end));
	            if ((trial_num>Npractice) && (trial_num<=Npairs))
	                is_correct = ~strcmp(gt_side{ii(k),trial_num},answer{ii(k),trial_num});
	                num_correct_per_img(j,i) = num_correct_per_img(j,i) + is_correct;
	                total_trials_per_img(j,i) = total_trials_per_img(j,i)+1;
	            end
	        end
	    end
	    percent_correct_per_img(j,:) = num_correct_per_img(j,:)./(total_trials_per_img(j,:)+eps);
	end
	total_correct = sum(num_correct_per_img,2);
	total_trials = sum(total_trials_per_img,2);
	total_percent = total_correct./total_trials;
	fprintf('\n');
	for j=1:length(which_algs)
	    x = cat(1,ones(total_correct(j,:),1),zeros(total_trials(j,:)-total_correct(j,:),1));
	    SEM = std(x)/sqrt(length(x));               % Standard Error
	    ts = tinv([0.025  0.975],length(x)-1);      % T-Score
	    CI = mean(x) + ts*SEM;                      % Confidence Intervals
	    fprintf('%s: %1.2f%% +/- %1.2f\n',which_algs{j},100*(1-total_percent(j,:)), 100*(CI(2)-CI(1))/2);%100*(1-CI(2)), 100*(1-CI(1)));
	end
	fprintf('\n');
    
    %%
    fooling_rate_by_time = zeros(4,15);
    for ii = 1:4
        num_correct_by_time = reshape(sum(num_correct_per_img(ii,:),1), [15,128]);
        num_trials_by_time = reshape(sum(total_trials_per_img(ii,:),1), [15,128]);
        
        fooling_rate_by_time(ii,:) = 1-sum(num_correct_by_time,2)./sum(num_trials_by_time,2);
        
        legend_names{ii} = strrep(opt.which_algs_paths{ii},'_',' ');
    end
    
    figure; hold on; grid on
    plot(fooling_rate_by_time', 'o-','linewidth', 2)
    xlabel('Synthesized Frame #')
    ylabel('Fooling rate')
    legend(legend_names)
    
    % number of people
    sum(total_trials_per_img(:))/(opt.Npairs-opt.Npractice)

    %%
    figure; hold on; grid on
    plot(movmean(fooling_rate_by_time',4), 'o-','linewidth', 2)
    xlabel('Synthesized Frame #')
    ylabel('Fooling rate')
    legend(legend_names)    
    
    %%
	[h,p] = ttest(percent_correct_per_img(strcmp(which_algs,'our_dna'),:)',percent_correct_per_img(strcmp(which_algs,'our_adv_dna'),:)');
% 	[h,p] = ttest(percent_correct_per_img(strcmp(which_algs,'classnorebal_turk_imgs_446000'),:)',percent_correct_per_img(strcmp(which_algs,'larsson_turk_imgs_0'),:)');

    %%
	i = strcmp(which_algs,'our_dna');
	j = strcmp(which_algs,'our_adv_dna');
	x = cat(1,ones(total_correct(i,:),1),zeros(total_trials(i,:)-total_correct(i,:),1));
	y = cat(1,ones(total_correct(j,:),1),zeros(total_trials(j,:)-total_correct(j,:),1));
	mu_x = mean(x);
	mu_y = mean(y);
	sig_x = var(x);
	sig_y = var(y);
	N_x = length(x);
	N_y = length(y);
	t = (mu_x-mu_y)/(sqrt((sig_x/N_x)+(sig_y/N_y)));
	v = (N_x - 1) + (N_y - 1);
	tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
	tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution
	
	p = 1-tdist2T(t,v)
	
	%%%% test subject means
	%%
% 	Nsubjs = opt.Nhits_per_alg*length(which_algs);
    Nsubjs = size(gt_side,1);
	percent_correct_per_img = [];
	num_correct_per_img = zeros(Nsubjs,length(which_algs),Nimgs);
	total_trials_per_img = zeros(Nsubjs,length(which_algs),Nimgs);
	for s=1:Nsubjs
	    fprintf('processing subject %d\n',s);
	    for j=1:length(which_algs)
	        for i=1:Nimgs
	            [ii,jj] = ind2sub(size(a(s+1,:)),find(strcmp(a(s+1,:),sprintf('%s/%d',which_algs{j},val_inds(i)))));
	            for k=1:length(jj)
	                tmp = a{1,jj(k)};
	                tmp2 = regexp(tmp,'\d');
	                trial_num = str2double(tmp(tmp2(1):end));
	                if ((trial_num>Npractice) && (trial_num<=Npairs))
	                    is_correct = ~strcmp(gt_side{s,trial_num},answer{s,trial_num});
	                    num_correct_per_img(s,j,i) = num_correct_per_img(s,j,i) + is_correct;
	                    total_trials_per_img(s,j,i) = total_trials_per_img(s,j,i)+1;
	                end
	            end
	        end
	        percent_correct_per_img(s,j,:) = num_correct_per_img(s,j,:)./(total_trials_per_img(s,j,:));
	    end
	end
	%%
	total_correct = sum(num_correct_per_img,3);
	total_trials = sum(total_trials_per_img,3);
	alg_means = total_correct./total_trials;
	A = alg_means(:,1); A = A(~isnan(A));
	B = alg_means(:,2); B = B(~isnan(B));
	
	1-mean(A)
	1-mean(B)
	[h,p] = ttest(A,B);
	p
	%%
	anova1(alg_means(:,[1,2]))
	
	
	%% bootstrap
	Nsamples = 1000;
	Nsubjs_per_alg = opt.Nhits_per_alg;
	samples = zeros(Nsamples,Nsubjs_per_alg,length(which_algs));
	for s=1:Nsamples
	    s
	    for a=1:length(which_algs)
	        for i=1:Nsubjs_per_alg
	            % sample random subject
	            ii = randi(Nsubjs_per_alg,1);
	            
	            tmp = sum(total_trials_per_img,3);
	            iii = find(tmp(:,a));
	            jjj = find(total_trials_per_img(iii(ii),a,:));
	            tmp = zeros(length(jjj),1);
	            for j=1:length(jjj)
	                % sample random pair
	                jj = randi(length(jjj),1);
	                tmp(j) = num_correct_per_img(iii(ii),a,jjj(jj));
	            end
	            samples(s,i,a) = mean(tmp);
	        end
	    end
	end
	%%
	a_ = 1-squeeze(mean(samples,2));
	%%
	sum(a_(:,1)<a_(:,2))/size(a_,1)
	%%
	which_alg_id = 2; which_algs{which_alg_id}
	mu = mean(a_(:,which_alg_id))
	sem = std(a_(:,which_alg_id))
	CI = prctile(a_(:,which_alg_id),[2.5,97.5])
	
	
	
	%%%% test random rate on each algorithm
	%%
	random_rates = zeros(size(alg_means,2),1);
	for i=1:size(alg_means,2)
	    ii = find(~isnan(alg_means(:,i)));
	    tmp = alg_means(ii,1);
	    random_rates(i) = mean(tmp(~isnan(tmp)));
	end
	1-random_rates'
	
	
	
	
	
	
	
	
	%%%% analyze per-image results
	%% sort images by how often they fooled people
	% load images
	r = 4;
	our_res = zeros(256+2*r+4,256+2*r+4,3,Nimgs,'single');
	gt_res = zeros(256+2*r+4,256+2*r+4,3,Nimgs,'single');
	alg_name = 'classrebal_turk_imgs_438000';
	for i=1:Nimgs
	    i
	    our_res(:,:,:,i) = padarray(padarray(im2double(imread(sprintf('../Results/res/camera_ready/%s/%d.png',alg_name,val_inds(i)))),[2,2],0),[r,r],255);
	    gt_res(:,:,:,i) = padarray(padarray(im2double(imread(sprintf('../Results/res/camera_ready/gt_imgs_0/%d.png',val_inds(i)))),[2,2],0),[r,r],255);
	end
	
	%%
	num_correct_per_img_gt = zeros(Nimgs,1);
	total_trials_per_img_gt = zeros(Nimgs,1);
	for i=1:Nimgs
	    [ii,jj] = ind2sub(size(a),find(strcmp(a,sprintf('gt_imgs_0/%d',val_inds(i)))));
	    ii=ii-1; % removes header
	    for k=1:length(ii)
	        tmp = a{1,jj(k)};
	        tmp2 = regexp(tmp,'\d');
	        trial_num = str2double(tmp(tmp2(1):end));
	        if ((trial_num>Npractice) && (trial_num<=Npairs))
	            is_correct = ~strcmp(gt_side{ii(k),trial_num},answer{ii(k),trial_num});
	            num_correct_per_img_gt(i) = num_correct_per_img_gt(i) + is_correct;
	            total_trials_per_img_gt(i) = total_trials_per_img_gt(i)+1;
	        end
	    end
	end
	percent_correct_per_img_gt = num_correct_per_img_gt./(total_trials_per_img_gt+eps);
	%hist(percent_correct_per_img_gt);
	
	ii_enough_N = find(total_trials_per_img_gt>5);
	[~,most_confused_ii] = sort(percent_correct_per_img_gt(ii_enough_N),'ascend');
	most_confused_ii = ii_enough_N(most_confused_ii);
	
	how_many = 9; montage_size = [3,3];
	subplot(221); montage(gt_res(:,:,:,most_confused_ii(1:how_many)),'Size',montage_size); title('thought fake, is real');
	subplot(222); montage(gt_res(:,:,:,most_confused_ii((end-how_many+1):end)),'Size',montage_size); title('thought real, is real');
	
	%%
	num_correct_per_img = zeros(Nimgs,1);
	total_trials_per_img = zeros(Nimgs,1);
	for i=1:Nimgs
	    [ii,jj] = ind2sub(size(a),find(strcmp(a,sprintf('%s/%d',alg_name,val_inds(i)))));
	    ii=ii-1; % removes header
	    for k=1:length(ii)
	        tmp = a{1,jj(k)};
	        tmp2 = regexp(tmp,'\d');
	        trial_num = str2double(tmp(tmp2(1):end));
	        if ((trial_num>Npractice) && (trial_num<=Npairs))
	            is_correct = ~strcmp(gt_side{ii(k),trial_num},answer{ii(k),trial_num});
	            num_correct_per_img(i) = num_correct_per_img(i) + is_correct;
	            total_trials_per_img(i) = total_trials_per_img(i)+1;
	        end
	    end
	end
	percent_correct_per_img = num_correct_per_img./(total_trials_per_img+eps);
	%hist(percent_correct_per_img);
	
	ii_enough_N = find(total_trials_per_img>10);
	[~,most_confused_ii] = sort(percent_correct_per_img(ii_enough_N)+0.00001*num_correct_per_img(ii_enough_N),'ascend');
	most_confused_ii = ii_enough_N(most_confused_ii);
	%%
	how_many = 12;
	to_display = [];
	for i=1:how_many
	    to_display = cat(1,to_display,cat(2,gt_res(:,:,:,most_confused_ii(i)),our_res(:,:,:,most_confused_ii(i))));
	end
	close all; imshow(padarray(to_display,[10,10],255));% title('most fooled');
	1-percent_correct_per_img(most_confused_ii(1:how_many))'
	export_fig('../figs/top_turk.pdf');
	
	
	to_display = [];
	for i=1:how_many
	    to_display = cat(1,to_display,cat(2,gt_res(:,:,:,most_confused_ii(end-i+1)),our_res(:,:,:,most_confused_ii(end-i+1))));
	end
	close all; imshow(padarray(to_display,[10,10],255));% title('least fooled');
	1-percent_correct_per_img(most_confused_ii((end-how_many+1):end))'
	export_fig('../figs/bot_turk.pdf');
	
	%%
	x = percent_correct_per_img;
	y = 1-percent_correct_per_img_gt;
	scatter(x,y);
	xlabel('how often clicked on when fake');
	ylabel('how often clicked on when real');
	
	P = polyfit(x,y,1);
	yfit = P(1)*x+P(2);
	
	r = corr(percent_correct_per_img,1-percent_correct_per_img_gt); title(sprintf('corr=%1.2f',r));
	set(gca,'xlim',[0,1]);
	set(gca,'ylim',[0,1]);
	hold on;
	%plot([0,1],[0,1],'--','Color',[0.7,0.7,0.7]);
	plot(x,yfit,'--','Color',[0.7,0.7,0.7]);
	
	%%
	[~,most_confused_ii] = sort(yfit-x,'descend');
	
	how_many = 25;
	subplot(121); montage(our_res(:,:,:,most_confused_ii(1:how_many))); title('most fooled normalized');
	%subplot(122); montage(gt_res(:,:,:,most_confused_ii(1:how_many))); title('most fooled normalized');
	subplot(122); montage(our_res(:,:,:,most_confused_ii((end-how_many+1):end))); title('least fooled normalized');
end







