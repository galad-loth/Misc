clear all;close all;clc
NumSample=50000;
x=500+75*randn(1,NumSample);
y=1000+75*randn(1,NumSample);
z=x+y;
QL=1:5:2500;NQ=length(QL);
hx=hist(x,QL)/NumSample;
hy=hist(y,QL)/NumSample;
hz=hist(z,QL)/NumSample;

figure(1);set(gcf,'position',[100 200 800 600])
fill([QL,fliplr(QL)],[hx,zeros(1,NQ)],[0.75 0.75 0.75],'LineStyle','none')
hold on;fill([QL,fliplr(QL)],[hy,zeros(1,NQ)],[0.6 0.6 0.6],'LineStyle','none')
hold on;fill([QL,fliplr(QL)],[hz,zeros(1,NQ)],[0.5 0.5 0.5],'LineStyle','none')

mu_x=mean(x);sigma_x=std(x);
px=(QL(2)-QL(1))*exp(-(QL-mu_x).^2/2/sigma_x/sigma_x)/sqrt(2*pi)/sigma_x;
mu_y=mean(y);sigma_y=std(y);
py=(QL(2)-QL(1))*exp(-(QL-mu_y).^2/2/sigma_y/sigma_y)/sqrt(2*pi)/sigma_y;

pzc=conv(px,py);
pz=pzc(1:length(QL));

figure(1);
hold on;plot(QL,px,'r--','LineWidth',2)
hold on;plot(QL,py,'g--','LineWidth',2)
hold on;plot(QL,pz,'b--','LineWidth',2)


%%
MY=zeros(NQ,NQ);
py_r=fliplr(py);
for kk=1:NQ
    MY(kk,1:kk)=py_r(NQ-kk+1:NQ);
end
pxt=px';
pzt=MY*pxt;
figure(1);hold on;plot(QL(1:25:end),pzt(1:25:end)','bd','LineWidth',2)
%%
pxt0=zeros(NQ,1);
beta=0.8;betaIR=0.85;
NumIter=3000;ThObj=1e-5;

pxt1=pdf_deconv(pzt,pxt0,MY,NumIter,beta,betaIR,ThObj);

figure(2);set(gcf,'position',[100 200 800 600])
fill([QL,fliplr(QL)],[px,zeros(1,NQ)],[0.6 0.6 0.6],'LineStyle','none')
% hold on;plot(QL(1:10:end),px(1:10:end),'rd','LineWidth',2)
hold on;plot(QL,pxt1','k-','LineWidth',2)
title(['End with IterNum=',num2str(kk)])

%%
sigma_x_g=NQ/12;
pxt0=exp(-(QL-NQ/2).^2/2/sigma_x_g/sigma_x_g)/sqrt(2*pi)/sigma_x_g;
pxt0=pxt0'/sum(pxt0);
% pxt0=pzt;
beta=0.2;betaIR=1.02;
NumIter=150;

for kk=1:NumIter
    beta=beta*betaIR;
    stepflag=0;endflag=0;
    while stepflag==0
        grad_now=2*MY'*MY*pxt0-2*MY'*pzt;
        pxt1=pxt0-beta*grad_now;
        pxt1(pxt1<0)=0;
        if sum(pxt1)>1
            pxt1=pxt1/sum(pxt1);
        end
        OBJ0=(pzt-MY*pxt0)'*(pzt-MY*pxt0);
        OBJ1=(pzt-MY*pxt1)'*(pzt-MY*pxt1);
        D_OBJ=OBJ0-OBJ1;
        if D_OBJ<0
            beta=beta/(betaIR+betaIR/100);
            if beta<1e-5
                stepflag=1;
                endflag=1;
            end
        else
            stepflag=1;
        end
    end
    if endflag==1
        break;
    end
    
    figure(2);set(gcf,'position',[100 200 800 600])
    fill([QL,fliplr(QL)],[hx,zeros(1,NQ)],[0.6 0.6 0.6],'LineStyle','none')
    hold on;plot(QL(1:10:end),px(1:10:end),'rd','LineWidth',2)
    hold on;plot(QL,pxt1','k-','LineWidth',2)
    title(['IterNum=',num2str(kk)])
    hold off;
    pause(0.05)
    if max(abs(pxt1-pxt0))<1/NQ*0.001
        break;
    end
    pxt0=pxt1;
end
pxt1=pxt1/sum(pxt1);
figure(2);set(gcf,'position',[100 200 800 600])
fill([QL,fliplr(QL)],[hx,zeros(1,NQ)],[0.6 0.6 0.6],'LineStyle','none')
hold on;plot(QL(1:10:end),px(1:10:end),'rd','LineWidth',2)
hold on;plot(QL,pxt1','k-','LineWidth',2)
title(['End with IterNum=',num2str(kk)])

