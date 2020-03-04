%% created by Arnold Sullivan
%% 03.03.2020 version 1.0.1
%% without the netcdf reading part

format shortg
    fs = 1;
    xfm = sum(imfs_fm(:,imf1:imf2),2); %%  23741          12(FM)
    xam = sum(sum(imfs_am(:,imf1:imf2,imfam1:imfam2),3),2); %%  23741          12(FM)          12(AM)
    xfm = xfm(endPt:end-endPt);
    xam = xam(endPt:end-endPt);
    data_fm = xfm ; data_am = xam;
    time = time(endPt:end-endPt);
N=length(xfm);
%% for IMFs FM
for nloop =1:100
    [u, ~] = findpeaks(abs(xfm) , N);
    [hmaxline,hminline] = myspline(time, abs(xfm), u , N);
    hmaxline = (hmaxline<.01)*.01 +  (~(hmaxline<.01)).*hmaxline ;
    xfm = xfm./hmaxline;
    xfm = (xfm>1).*1 + (~(xfm>1)).*xfm;
    xfm = (xfm<-1).*-1 + (~(xfm<-1)).*xfm;
end
    yfm = hilbert(xfm);
    amp_fm = data_fm ./ xfm;
    inffm = fs/(2*pi)*diff(unwrap(angle(yfm)));
    v1 = 1./mean(inffm(2000:end-2000));

%% for IMFs AM
for nloop =1:100
    [u, ~] = findpeaks(abs(xam) , N);
    [hmaxline,hminline] = myspline(time, abs(xam), u , N);
    hmaxline = (hmaxline<.01)*.01 +  (~(hmaxline<.01)).*hmaxline ;
    xam = xam./hmaxline;
    xam = (xam>1).*1 + (~(xam>1)).*xam;
    xam = (xam<-1).*-1 + (~(xam<-1)).*xam;
end
    yam = hilbert(xam);
    amp_am = data_am ./ xam;
    infam = fs/(2*pi)*diff(unwrap(angle(yam)));
    v2 = 1./mean(infam(2000:end-2000)); %% the mean of 1./inf
    v3 = mean(amp_am(2000:end-2000)); %% the mean of the abs(env)

