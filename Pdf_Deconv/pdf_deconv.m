function p_deconv=pdf_deconv(pc,p0,KerConv,MaxNumIter,beta0,betaIR,ThObj)
for kk=1:MaxNumIter
    beta=beta0;
    stepflag=0;endflag=0;
    while stepflag==0
        grad_now=2*KerConv'*KerConv*p0-2*KerConv'*pc;
        p01=p0-beta*grad_now;
        p01( p01<0)=0;
        if sum(p01)>0
            p01=p01/sum(p01);
        end
        OBJ0=(pc-KerConv*p0)'*(pc-KerConv*p0);
        OBJ1=(pc-KerConv*p01)'*(pc-KerConv*p01);
        D_OBJ=OBJ0-OBJ1;
        if sqrt(OBJ1)<ThObj
            endflag=1;
            stepflag=1;
        end
        if D_OBJ<0
            beta=beta*betaIR;
            if beta<1e-10
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
    p0=p01;
    disp(['performing pdf_deconv, the ',num2str(kk),'th iteration,ValOBJ=',num2str(OBJ1)])
end
disp(['pdf_deconv end at the ',num2str(kk),'th iteration,ValOBJ=',num2str(OBJ1)])
p_deconv=p01/sum(p01);