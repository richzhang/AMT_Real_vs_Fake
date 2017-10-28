function [opt] = getOpts(expt_name)
	
	switch expt_name
		case 'example_expt'
			opt = getDefaultOpts();
		
			opt.which_algs_paths = {'my_alg','baseline_alg'};
            opt.Nimgs = 100;                        % number of images to test
            opt.Npairs = 60;                        % number of paired comparisons per HIT
            opt.Npractice = 10;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
			opt.ut_id = '1951962b7f88dcf6924243f457202a77'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'https://www.mywebsite.com/example_expt_data/';
        	opt.gt_path = 'gt';                     % path to gt images
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.paired = true;
            opt.vigilance_freq = 0.1;               % percent of trials that are vigilance tests
            opt.use_vigilance = false;               % include vigilance trials (obviously fake images to check that Turkers are paying attention)	
        	opt.paired = true;                      % if true, then fake/n.jpg will be pitted against real/n.jpg; if false, fake/n.jpg will be pitted against real/m.jpg, for random n and m

        case 'iclr17'
			opt = getDefaultOpts();
		
			opt.which_algs_paths = {'cdna','sna','our_dna','our_adv_dna'};
            opt.Nimgs = 1920;                        % number of images to test
            opt.Npairs = 70;                        % number of paired comparisons per HIT
            opt.Npractice = 20;                     % number of practice trials per HIT (number of non-practice trials is opt.Npairs-opt.Npractice)
			opt.ut_id = '1951962b7f88dcf6924243f457202a77'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'http://colorization.eecs.berkeley.edu/_tmp_host/vidpred/iclr_results/results_proc2/';
        	opt.gt_path = 'gt';                     % path to gt images
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
            opt.vigilance_freq = 0.1;               % percent of trials that are vigilance tests
            opt.use_vigilance = false;               % include vigilance trials (obviously fake images to check that Turkers are paying attention)	
        	opt.paired = false;                      % if true, then fake/n.jpg will be pitted against real/n.jpg; if false, fake/n.jpg will be pitted against real/m.jpg, for random n and m
        	opt.Nhits_per_alg = 50;                 % number of HITs per algorithm
		otherwise
			error(sprintf('no opts defined for experiment %s',expt_name));
	end
	
	opt.expt_name = expt_name;
end