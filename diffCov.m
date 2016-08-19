function [SLdcov, dp, dcov, SLcov, P, Csample] = diffCov( data )
%---------------------------------------------
%Desc: The main program for computing the differential covariance
%input: 
%data is a TxN matrix where T is time, N is # of neurons/channels/voxels......
%output:
%SLdcov: the sparse+latent regularized diffCov. i.e. the final estimation
%of the diffCov method
%dp: the partial correlation version of the diffCov
%dcov: the naive differential correlation
%SLcov: the sparse+latent regularized covariance
%P: the precision matrix
%Csample: the covariance method
%
%The inexact_alm_rpca package is needed for the sparse+latent
%regularization. Download it to directory that contains this function.
%http://perception.csl.illinois.edu/matrix-rank/Files/inexact_alm_rpca.zip
%
%change verbose to 1 for visualization of results
%
%Created by Tiger Lin, the Computational Neurobiology Lab-Sejnowski,
%the Salk Institute
%---------------------------------------------
addpath('./inexact_alm_rpca');
addpath('./inexact_alm_rpca/PROPACK');
verbose = 0;


%% Step1: compute diffCov
N = size(data,2);
V = data;

I = -1/2*V(1:end-2,:) + 1/2*V(3:end,:);
I = [mean(I);I ; mean(I)];

VI_Csample = cov([V I]);
dcov = VI_Csample(N+1:N+N,1:N);
nodiag_dcov = dcov - diag(diag(dcov));

%% Step2: apply partial correlation to diffCov
dp = regC2(VI_Csample);
nodiag_dp = dp - diag(diag(dp));

%% Step3: apply sparse+latent regularization

lambda = 1/sqrt(max(size(nodiag_dp)));
[Residue_cov, SLdcov,~] = inexact_alm_rpca(nodiag_dp, lambda);
nodiag_SLdcov = SLdcov - diag(diag(SLdcov));

%% ---------------other methods for reference---------------------------
Csample = cov(V);
nodiag_Csample = Csample - diag(diag(Csample));

%% precision matrix
P = inv(Csample);
nodiag_P = P - diag(diag(P));

%% SL-reg precision matrix

lambda = 1/sqrt(max(size(P)));
[Residue_dcov, SLcov,~] = inexact_alm_rpca(P, lambda);

%% optional plots
if verbose
    figure(1)
    subplot(2,3,1)
    imagesc(nodiag_Csample)
    title('Cov')
    subplot(2,3,2)
    imagesc(nodiag_P)
    title('inv(C)')
    subplot(2,3,3)
    imagesc(SLcov - diag(diag(SLcov)))
    title('cov SL')
    subplot(2,3,4)
    imagesc(Residue_cov)
    title('Residue')

    
    figure(2)
    subplot(2,3,1)
    imagesc(nodiag_dcov)
    title('diffCov')
    subplot(2,3,2)
    imagesc(nodiag_dp)
    title('diffCov partial')
    subplot(2,3,3)
    imagesc(nodiag_SLdcov)
    title('diffCov SL')
    subplot(2,3,4)
    imagesc(Residue_dcov)
    title('Residue')
end