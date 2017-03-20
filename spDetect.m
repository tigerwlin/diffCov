%%
clear all
addpath('/netapp/cnl/home/wulin/research/paper/ivCOV_paper/supp/wave_clus-testing/Batch_files');
% dic = '/cnl/chaos/sim_sleep_data/Transition/1D_model/reducedModel/cxcx_56/fullModel/oneSide/longRun/postSynCurrent/out2';
% dic = '/cnl/chaos/sim_sleep_data/kaggle_connectomics/normal-4/cxin_model/out';
% dic = '/cnl/data/wulin_data/kaggle_connectomics/superSmall/cxin_model/out';
% dic = '/cnl/data/wulin_data/kaggle_connectomics/small/cxin_model6/out';
% cxLd = load([dic '/neuron.mat']);
% cx = cxLd.cx;
% in = cxLd.in;
% sp = [cx(:, 2:2:end-1), in(:, 2:end)];
% clearvars cx in cxLd
% sp = cx(:,3:2:end-1);

dic = '/cnl/chaos/sim_sleep_data/Transition/1D_model/reducedModel/cxcx_56789/fullModel/oneSide/2layer/postSynCurrent/out3';
% cxLd = load([dic '/lfp.mat']);
% lfp = cxLd.lfp;
% sp = lfp;
cxLd = load([dic '/mri.mat']);
newV = cxLd.newV;
sp = newV;

debug = 0;
% sp = sp(:,48);
%%
par.sr = 1000;
par.w_pre = 20;
par.w_post = 20;
par.ref = 10;
par.stdmin = 5;                      % minimum threshold for detection 
par.stdmax = 1000;                     % maximum threshold for detection 
par.detect_fmin = 10;               % high pass filter for detection 
par.detect_fmax = 499;              % low pass filter for detection (default 1000) 
par.sort_fmin = 10;                 % high pass filter for sorting 
par.sort_fmax = 499;                % low pass filter for sorting (default 3000) 
par.detection = 'pos';               % type of threshold 
par.detect_order = 4; 
par.sort_order = 2;
par.int_factor = 2;                  % interpolation factor 
par.interpolation = 'y';             % interpolation with cubic splines (default) 

sps = sp*0;

for i = 1:size(sp,2)
    disp(i)
    [spikes,thr,index] = MY_amp_detect(sp(:,i)', par);
    sps(index, i)=1;
end
%%
if debug
    figure(31)
    neuronIdx = 23;
    subplot(2,2,1)
    plotIdx = 3424:6424;
    spIdx = find(sps(plotIdx, neuronIdx)==1) + plotIdx(1)-1;
    plot(plotIdx, sp(plotIdx, neuronIdx), spIdx, 0, 'ro')
    subplot(2,2,2)
    plotIdx = 13424:16424;
    spIdx = find(sps(plotIdx, neuronIdx)==1) + plotIdx(1)-1;
    plot(plotIdx, sp(plotIdx, neuronIdx), spIdx, 0, 'ro')
    subplot(2,2,3)
    plotIdx = 23424:26424;
    spIdx = find(sps(plotIdx, neuronIdx)==1) + plotIdx(1)-1;
    plot(plotIdx, sp(plotIdx, neuronIdx), spIdx, 0, 'ro')
    subplot(2,2,4)
    plotIdx = 33424:36424;
    spIdx = find(sps(plotIdx, neuronIdx)==1) + plotIdx(1)-1;
    plot(plotIdx, sp(plotIdx, neuronIdx), spIdx, 0, 'ro')
end
%%
save([dic '/mri_spike.mat'], 'sps', '-v7.3')
