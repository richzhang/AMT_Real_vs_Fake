function [opt] = getOpts(expt_name)
	
	switch expt_name
        
		case 'example_expt'
			opt = getDefaultOpts();
			opt.which_algs_paths = {'my_alg','baseline_alg'};
			opt.Nimgs = 1000;
			opt.ut_id = '94149d445af4a3af8dd5d41614353c0b'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'https://www.mywebsite.com/example_expt_data/';
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.paired = true;

		case 'perceptual'
			opt = getDefaultOpts();
			opt.which_algs_paths = {'p0','p1'};
            opt.gt_path = 'ref';
			opt.Nimgs = 100;
			opt.ut_id = '94149d445af4a3af8dd5d41614353c0b'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'https://eecs.berkeley.edu/~rich.zhang/research/2017_07_perceptual/easy_collect_richard/';
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.paired = true;
		            
		case 'perceptual_mod_adobe'
			opt = getDefaultOpts();
			opt.which_algs_paths = {'p0','ref','p1'};
%             opt.gt_path = 'ref';
            opt.Nimgs = 2000;                        % number of images to test
            opt.Npairs = 105;                        % number of paired comparisons per HIT
            opt.Npractice = 5;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
            opt.Nhits_per_alg = 100;                 % number of HITs

            opt.ut_id = '94149d445af4a3af8dd5d41614353c0b'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'https://eecs.berkeley.edu/~rich.zhang/research/2017_07_perceptual/easy_collect_richard_adobe_32_4/';
			opt.instructions_file = './instructions_basic_mod.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic_mod.html';

            opt.use_vigilance = true;
			opt.vigilance_path = 'vigilance';
            opt.Nvigilance = 1000;                  % number of vigilance images available
        	opt.vigilance_freq = .1;               % percent of trials that are vigilance tests
            
            opt.im_height = 32;                    % dimensions at which to display the stimuli
            opt.im_width = 32;                     %
            
            opt.paired = true;

		case 'perceptual_mod_amt' % amt_trial_v0
			opt = getDefaultOpts();
			opt.which_algs_paths = {'p0','ref','p1'};
%             opt.gt_path = 'ref';
            opt.Nimgs = 27500;                        % number of images to test
            opt.Npairs = 810;                        % number of paired comparisons per HIT
%             opt.Npairs = 11;                        % number of paired comparisons per HIT
            opt.Npractice = 10;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
%             opt.Npairs = 10;                        % number of paired comparisons per HIT
%             opt.Npractice = 5;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
            opt.Nhits_per_alg = 25;                 % number of HITs

            opt.ut_id = '9fb34d6b841e054b4035cb67409d4108'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'http://colorization.eecs.berkeley.edu/_tmp_host/2017_09_perceptual/vgg_collect_32_VGG_5/';
            opt.instructions_file = './instructions_basic_mod.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic_mod.html';

            opt.use_vigilance = true;
			opt.vigilance_path = 'vigilance';
            opt.Nvigilance = 1000;                  % number of vigilance images available
%         	opt.vigilance_freq = .1;               % percent of trials that are vigilance tests
        	opt.vigilance_freq = .025;               % percent of trials that are vigilance tests
            
            opt.im_height = 32;                    % dimensions at which to display the stimuli
            opt.im_width = 32;                     %
            
            opt.paired = true;

        case 'perceptual_mod_amt_v1'
			opt = getDefaultOpts();
			opt.which_algs_paths = {'p0','ref','p1'};
%             opt.gt_path = 'ref';
            opt.Nimgs = 10000;                        % number of images to test
%             opt.Npairs = 810;                        % number of paired comparisons per HIT
            opt.Npairs = 11;                        % number of paired comparisons per HIT
            opt.Npractice = 10;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
%             opt.Npairs = 10;                        % number of paired comparisons per HIT
%             opt.Npractice = 5;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
            opt.Nhits_per_alg = 25;                 % number of HITs

            opt.ut_id = '9fb34d6b841e054b4035cb67409d4108'; % set this using http://uniqueturker.myleott.com/
%             opt.ut_id = 'd88297e141aa15cee9d225d4a38d58a2';
% 			opt.base_url = 'http://colorization.eecs.berkeley.edu/_tmp_host/2017_09_perceptual/vgg_collect_32_VGG_5/';
            opt.base_url = 'http://colorization.eecs.berkeley.edu/_tmp_host/amttrial1/amttrial1_vgg_64_collect0/';
%             opt.base_url = 'http://colorization.eecs.berkeley.edu/_tmp_host/amttrial1/autoencoder_collect_64/';
            opt.instructions_file = './instructions_basic_mod.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic_mod.html';

            opt.use_vigilance = true;
			opt.vigilance_path = 'vigilance';
            opt.Nvigilance = 1000;                  % number of vigilance images available
%         	opt.vigilance_freq = .1;               % percent of trials that are vigilance tests
        	opt.vigilance_freq = .025;               % percent of trials that are vigilance tests
            
            opt.im_height = 64;                    % dimensions at which to display the stimuli
            opt.im_width = 64;                     %
            
            opt.paired = true;
        
        otherwise
			error(sprintf('no opts defined for experiment %s',expt_name));
	end
	
	opt.expt_name = expt_name;
end