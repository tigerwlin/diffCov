function  C = regC2(Csample)
%--------------------------------------------
%apply customized partial correlation 
%Csample is a 2N x 2N matrix computed from cov([data diff_data])

%Created by Tiger Lin, the Computational Neurobiology Lab-Sejnowski,
%the Salk Institute
%--------------------------------------------
I_N = size(Csample,1)/2;
V_N = I_N;

CsampleVV = Csample(1:V_N,1:V_N);
CsampleIV = Csample(V_N+1:V_N+I_N,1:V_N);

C = zeros(I_N, V_N);
for i = 1:I_N    %the I value
    for j = 1:V_N   %the V value

        if i <= j
            uIdx = [1:i-1,i+1:j-1,j+1:V_N];
        else
            uIdx = [1:j-1,j+1:i-1,i+1:V_N];
        end
        %----------------------------------------------------
        Sy1u = CsampleIV(i, uIdx);
        Sy2u = CsampleVV(j, uIdx);
        %----------------------------------------------------
        C(i,j) = CsampleIV(i,j) - Sy2u/CsampleVV(uIdx, uIdx)*Sy1u';
        %----------------------------------------------------
    end
end

