function [] = mk_expt(expt_name)

%% expt parameters
opt = getOpts(expt_name);

%% check parameters
checkOpts(opt);

%% make dir for expt, overwriting if it already exists
if (exist(opt.expt_name,'dir'))
    system(sprintf('rm -r ./%s',opt.expt_name));
end
mkdir(opt.expt_name);
fprintf('Experiment name: %s\n',opt.expt_name)

%%
rng('shuffle');

%%
csv_fname = fullfile(opt.expt_name,sprintf('expt_input_data.csv'));

images_p0 = {};
images_ref = {};
images_p1 = {};

for i=1:opt.Npairs
    images_p0{1,i} = sprintf('images_p0_%i',i);
    images_ref{1,i} = sprintf('images_ref_%i',i);
    images_p1{1,i} = sprintf('images_p1_%i',i);
end

% for which_alg_curr=1:length(opt.which_algs_paths) % each trial tests just one alg
for j=1:opt.Nhits_per_alg % number of hits

    % vigilance indices
    Nvigil_total = 0;
    if(opt.use_vigilance)
        vigilance_inds = zeros(1,opt.Npairs);
        Nvigil_practice = ceil(opt.vigilance_freq*opt.Npractice);
        Nvigil_real = ceil(opt.vigilance_freq*(opt.Npairs-opt.Npractice));
        Nvigil_total = Nvigil_practice + Nvigil_real;

        which_imgs_vig = randperm(opt.Nvigilance)-1;
        which_imgs_vig = which_imgs_vig(1:Nvigil_total); % test images

        vigil_inds_practice = randperm(opt.Npractice);
        vigil_inds_practice = vigil_inds_practice(1:Nvigil_practice);
        vigilance_inds(vigil_inds_practice) = which_imgs_vig(1:Nvigil_practice); % put test image indices into vigilance

        vigil_inds_real = randperm(opt.Npairs-opt.Npractice);
        vigil_inds_real = vigil_inds_real(1:Nvigil_real)+opt.Npractice;
        vigilance_inds(vigil_inds_real) = which_imgs_vig(Nvigil_practice+1:end); % put test image indices into vigilance
    end

    % actual test images
%     which_imgs_alg = randperm(opt.Nimgs)-1;
%     which_imgs_alg = which_imgs_alg(1:opt.Npairs); % choose random set of images to test on, from test set
%     which_imgs_alg = (j-1)*(opt.Npairs-Nvigil_total) + (1:(opt.Npairs-Nvigil_total));
%     which_imgs_alg = [which_imgs_alg max(which_imgs_alg(:))+zeros(1,Nvigil_total)];
    which_imgs_alg = (j-1)*(opt.Npairs-Nvigil_total) + (0:opt.Npairs-1);
    for vigilance_ind = find(vigilance_inds)
        which_imgs_alg(vigilance_ind:end) = which_imgs_alg(vigilance_ind:end)-1;
        which_imgs_alg(vigilance_ind) = 0;
    end
    assert(max(which_imgs_alg) < opt.Nimgs)

    for i=1:opt.Npairs
%             if (opt.use_vigilance && (rand(1)<=opt.vigilance_freq)) % opt.vigilance_freq proportion of trials are vigilance checks
%                 alg_im_name = sprintf('%s/%06d',opt.vigilance_path,which_imgs_alg(i));
%             else
%                 alg_im_name = sprintf('%s/%06d',opt.which_algs_paths{which_alg_curr},which_imgs_alg(i));
%             end

        if(vigilance_inds(i))
%             fprintf('hello')
            images_p0{j+1,i} = sprintf('%s/%s/%06d',opt.vigilance_path,'p0',vigilance_inds(i));
            images_ref{j+1,i} = sprintf('%s/%s/%06d',opt.vigilance_path,'ref',vigilance_inds(i));
            images_p1{j+1,i} = sprintf('%s/%s/%06d',opt.vigilance_path,'p1',vigilance_inds(i));
        else
            images_p0{j+1,i} = sprintf('%s/%06d','p0',which_imgs_alg(i));
            images_ref{j+1,i} = sprintf('%s/%06d','ref',which_imgs_alg(i));
            images_p1{j+1,i} = sprintf('%s/%06d','p1',which_imgs_alg(i));
        end
    end
end

A = cat(2,images_p0,images_ref,images_p1);

% randomize HIT order (I think MTurk does this but let's do it here as well for safety)
% rp = randperm(size(A,1)-1)+1;
% A = A([1,rp],:);

fid = fopen(csv_fname,'w');
for i=1:size(A,1)
    for j=1:size(A,2)-1
        fprintf(fid,[A{i,j},',']);
    end
    fprintf(fid,A{i,end});
    fprintf(fid,'\n');
end
fclose(fid);


%% html code generator
html = fileread('index_template_mod.html');

html = strrep(html, '{{UT_ID}}', opt.ut_id);
html = strrep(html, '{{BASE_URL}}', opt.base_url);

html = strrep(html, '{{INSTRUCTIONS}}', fileread(opt.instructions_file));
html = strrep(html, '{{SHORT_INSTRUCTIONS}}', fileread(opt.short_instructions_file));
html = strrep(html, '{{CONSENT}}', fileread(opt.consent_file));

html = strrep(html, '{{IM_DIV_HEIGHT}}', num2str(opt.im_height+2));
html = strrep(html, '{{IM_DIV_WIDTH}}', num2str(opt.im_width+2));
html = strrep(html, '{{IM_HEIGHT}}', num2str(opt.im_height));
html = strrep(html, '{{IM_WIDTH}}', num2str(opt.im_width));

html = strrep(html, '{{N_PRACTICE}}', num2str(opt.Npractice));
html = strrep(html, '{{TOTAL_NUM_IMS}}', num2str(opt.Npairs));

s = [];
for i=1:opt.Npairs
    s = cat(2,s,sprintf('sequence_helper("${images_p0_%i}","${images_ref_%i}","${images_p1_%i}");\n',i,i,i));
end
html = strrep(html, '{{SEQUENCE}}', s);

s = [];
for i=1:opt.Npairs
    s = cat(2,s,sprintf('<input type="hidden" name="selection%i" id="selection%i" value="unset">\n',i,i));
end
html = strrep(html, '{{SELECTION}}', s);

fprintf('Html file made: %s\n',fullfile(opt.expt_name,'index.html'))
fid = fopen(fullfile(opt.expt_name,'index.html'),'w');
fprintf(fid,'%s',html);
fclose(fid);


end

