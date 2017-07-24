# -*- coding: utf-8 -*-
"""
Created on Mon Jul  4 18:23:30 2016

@author: claire
"""

""" S and P phases picking following (Baillard 2014)
Functions : 
    
    - CFKurtosis :Characteristic function (CF) of the trace :  Kurtosis
    - F2 : Clean Cf of negative gradients
    - F3 :Remove linear trend of F2
    - MeanF3: Smooth F3
    - F4 : Greatest minima correspond to the greatest onset strenghts
    - F4prim : slim F4
    - DR :  Dip-rectinarity function
    - PSswavefilter :  P and S wave filter ( Ross et al 2016 )
    - WavePicking : P and S wave picking 
polarisation: calculate the degreee of rectinearility and the dip of maximum polarization
"""
import math
import numpy as np
import scipy
from obspy.signal.polarization import polarization_analysis
import matplotlib.pylab as plt

def CFkurtosis(tr,T, df):
    """return the caracteristic function based on the cumulative kurtosis calculate over a 5 second time window for the S wave picking 
    after trying I found that P picking is better when the kurtosis[i] is calculated on a center windows tr.data[i-T*100+1:i+1]
    input : 
        - tr: trace 
        - T : int, windows size in second
        - df : int,  samplin rate 
    output :
        - Cf Characteristic function which is the cumulative kurtosis calculated over T second time windows 
    exemple :
        for a period T = 5 seconds 
        Cf = CFkurtosisS(tr.data,5,100) """
        
    N = T*df
    Cf =np.zeros((1,N)) 
    cf = []
    for i in xrange(N, len(tr.data)):
        # the Kusrtosis is calculated on a T second moving windows 
        data = tr.data[i-N+1:i+1]  
        #Kurtosis calculation as follow the Pearson definition
        Kurtosis =  scipy.stats.kurtosis(data, axis = 0, bias=False, fisher=False) 
        cf.append(Kurtosis)
    Cf = np.append(Cf, np.array(cf))

    return Cf    

def F2(Cf):
    """ remove the negative slope of the characteristic function calculated as the sliding kurtosis fonction
    input :
        Cf: 1D array, Kurtosis characteristic funtion calculated with CFkurtosis 
    output:
        F2: 1D array,  Cf cleaned of negative gradients
    exemple :
        Cf = CFkurtosis(tr.data,5,100)
        F2 = F2(Cf)
    """
    F2=np.zeros(Cf.shape)
    F2[0]=Cf[0]
    print Cf.shape, "cf"
    for i in xrange(len(Cf)-1):
        df1 = Cf[i+1]-Cf[i]
        if df1<0:
            delta =0
        else :
            delta =1
            
        F2[i+1] =F2[i]+delta*df1
    return F2
        
def F3(F2):
    """ remove the linear trend of F2
    input:
        - F2: 1D array, Cf cleaned of negative gradients
    output:
        - F3: 1D array, F2 without linear trend
    exemple:
        Cf = CFkurtosis(tr.data,5,100)
        F2 = F2(Cf)
        F3 = F3(F2)
        """
    
    F3= np.zeros(F2.shape)
    a = (F2[len(F2)-1]-F2[0])/(len(F2)-1)
    b = F2[1]
    for i in xrange(1,len(F3)):
        F3[i]=F2[i]-(a*(i-1)+b)
    #   shift the F3 component to the left
    F3=np.array([F3[i-1] for i in xrange(1,len(F3))])
    F3 = np.append([0],F3)
    return F3
    
def MeanF3(F3,WT):
    """ Smooth F3 
    imput:
        -F3: 1D array, removal of the linear trend of F2
        -WT: int, smoothing windowss size in second 
    output :
        -F3mean: 1D array, F3 smoothed
        
    exemple:
        f3mean = MeanF3(F3,1)
"""    
    F3mean=np.zeros(F3.shape)
    Wt=int(100*WT)
    for i in xrange(len(F3)-Wt):
        F3mean[i]=np.mean(F3[i:i+Wt])   
    return F3mean
    
    
def F4(F3):
    """Greatest minima correspond to the greatest onset strenghts
    input : 
        -F3: 1D array, F2 cleaned of a linear trend and smooth
    output :
        -F4: 1D array,picking minima on F4 give a good estimate on phase onset 
        
    exemple :
        f4 = F4(F3)
    """
    F4 = np.zeros(F3.shape)
    T=np.zeros(F3.shape)
    for i in xrange((len(F3)-1)):
        T[i]=F3[i]-max(F3[i],F3[i+1])
        if T[i]<0:
            F4[i]=T[i]
        else : 
            F4[i]=0
    return F4
    
def F4prim(F4):
    """Slim the minimum of F4
    input : 
        -F4: 1D array, function where the greatest minima correspond to the greatest onset strenghts
    output :
        -F4prim: 1D array, Slim F4
    exemple :
        f4prim = F4prim(F3)
    """
    F4prim = np.zeros(F4.shape)
    for i in xrange((len(F4prim)-1)):
        # f4 IS NEGATIVE
        F4prim[i]=F4[i]-max(F4[i],F4[i+1])       
    return F4prim
    
def DR(rectilinearity, dip,alpha):
    """calculate the dip-rectilinearity function defined in Baillard et al 2014
        Above TP ,the pick is declared as P; below Ts , the pick is declared as S.Ts=-Tp =-0.4 (but have to be tested)
    input 
        -rectilineariuty :type array rectilinearity calculated from flinn
        -dip : type array : dip calculated from flinnn polarisation analysis     
        -alpha: float,  weightweighting factor between 1 and 2 that depends on the clarity
                of the dip and rectilinearity: a value of 2 would be appropri-
                ate for perfectly polarized data, and 1 corresponds to poorly
                polarized data.
    output:
         -DR: array dip-rectinearity (help to determine if P or S wave)
    """
    DR = np.array([rectilinearity(i)*np.sign(alpha * math.sin(dip(i))-rectilinearity(i)) for i in xrange(len(rectilinearity))])
    return DR
    
def PSswavefilter(rectilinearity,incidence):
    """ p and s wave filter arrays based on Ross et al 2016 
    input : 
        - rectilinearity: type array, rectilinearity calculated from polarisation analysis
        -incidence : type rray calculated from polarisation analysis (flinn 1988 )
    output : 
        - pfilter: type np array; filter of p wave (the convolution with the row signal will remove the s phase)
        - sfilter :type np array s filter (the convolution with the row signal will remove the p phase)
    exemple:
        sfilter, pfilter = PSswavefilter(rectilinearity,incidence)
        Ssignal = sfilter * tr.data
    """
    sfilter = rectilinearity*(np.ones(len(incidence))-np.cos(incidence*math.pi/180))
    pfilter = rectilinearity*(np.cos(incidence*math.pi/180))
    return sfilter, pfilter
    
def WavePicking(st,T, SecondP,SecondS,plot):
    """  P and S Phase picking
    -input:
        -st : stream contain the 3 component of the signal
        -T : float, 5s time of the sliding windows see baillard but could be change trial shoaw goiod result with 5s. 
        -plot: bool, if true plot will be draw
        -SecondP, float theorical P arrival in second 
        -Seconds,float theorical S arrival in second 
    -output
        - minF4p: float, coordiantes of the p start in second
        - minF4s: float, coordiantes of the s start in second calculating using the kitosis derived function and rectilinearity
    -exemple:
        minF4p, minF4s = WavePicking3(st_copy,5, 0,10,True)
        """
    # initialisation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    st=st.copy()
    trZ = st.select(component = 'Z')[0]
    trN = st.select(component = 'E')[0]
    df = trZ.stats.sampling_rate
    tr_copy = trZ.copy()
    trN_copy = trN.copy()
    tr_copy2 = trZ.copy()
    P_Sdelay = (SecondS-SecondP)
    
    # Trim signal  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if SecondP > 60*5: 
        a=trZ.stats.starttime 
        tr_copy.trim(starttime =a + SecondP-60)
        trN_copy.trim(starttime =a + SecondP-60)
        SecondP =SecondP-60
        if tr_copy.stats.endtime - tr_copy.stats.starttime> 10*60 : 
            trN_copy.trim(endtime = a + SecondP+60*10)
            tr_copy.trim(endtime = a + SecondP+60*10)
            st.trim(endtime = a + SecondP+60*10)
    elif  tr_copy.stats.endtime - tr_copy.stats.starttime> 10*60 :
        a=trZ.stats.starttime 
        trN_copy.trim(endtime = a + SecondP+60*10)
        tr_copy.trim(endtime = a + SecondP+60*10)
        st.trim(endtime = a + SecondP+60*10)
        
    # P phase arrival picking~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Cf = CFkurtosis(tr_copy,T) 
    f2 = F2(Cf)
    f3 = F3(f2)
    f3mean = MeanF3(f3,0.5) #sliding windows of 0.5 s show good results 
    f4 = F4(f3mean)   
    f4prim = F4prim(f4)  
    
    # S phase arrival picking~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CfN = CFkurtosis(trN_copy,T)
    f2N = F2(CfN)
    f3N = F3(f2N)
    f3meanN = MeanF3(f3N,0.5) #sliding windows of 0.5 s show good results 
    f4N = F4(f3meanN)
    f4primN = F4prim(f4N)

    #polarisation analysis ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    start1 = trN_copy.stats['starttime']
    for tr in st : 
        start = tr.stats['starttime']
        if start>start1 :
            start1 = start 
            
    pol = polarization_analysis(st,5,0.1,0.1,20,start1,trN_copy.stats['endtime'], verbose=False, method='flinn' , var_noise=0.0)
    rectilinearity = pol['rectilinearity']
    incidence = pol['incidence']
    rectilinearity2 = scipy.signal.resample(rectilinearity, len(f4prim),axis=0)
    incidence2= scipy.signal.resample(incidence, len(f4prim),axis=0)
    
    #P S filter cf Ross 2016 
    sfilter, pfilter =  PSswavefilter(rectilinearity2,incidence2)
    tr_copyS = trN_copy.copy() 
    tr_copyP = tr_copy.copy()
    tr_copyS = tr_copyS.data * sfilter
    tr_copyP = tr_copyP.data * pfilter
    
    # P and S wave picking  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    minF4p =100*2+ np.argmin(f4prim[100*2:len(f4prim)-100*2]) #avoisd to point the end and begin of the siganl!
    if sfilter[minF4p]>0.4 :  #NOT A p WAVE HD/Working/WavePicking_%s.png'%component,dpi=300)       
        LminF4p2 = np.argwhere((f4prim[100*2:len(f4prim)-100*2]<0.01*minF4p)&(sfilter[100*2:len(f4prim)-100*2]<0.4))
        if len(LminF4p2)<>0:        
            Minp = LminF4p2[0]        
            for Min in LminF4p2 : 
                if f4prim[Min]<=f4prim[Minp]:
                    Minp = Min
            minF4p = 100*2+Minp  # P picking

    if isinstance(minF4p,(list, tuple,np.ndarray))==True :
        minF4p = minF4p[0]
  
    min2F4s2 = np.argmin(f4primN[minF4p+(1-0.20)*P_Sdelay*100:minF4p+(1-0.20)*P_Sdelay*100 +60*100])
    minF4s2 = minF4p+(1-0.20)*P_Sdelay*100+min2F4s2
    if sfilter[minF4s2]<0.25 :  #NOT A S WAVE S limite 
        LminF4s2 = np.argwhere((f4primN[minF4p+(1-0.20)*P_Sdelay*100:minF4p+(1-0.20)*P_Sdelay*100 +15*100]<0.2*f4primN[minF4s2]))
        if len(LminF4s2)<>0:        
            Mins = LminF4s2[0]   
            for Min in LminF4s2 : 
                if f4prim[Min]<=f4prim[Mins]:
                    Mins = Min
            minF4s2 = minF4p+(1-0.20)*P_Sdelay*100+Mins
    if isinstance(minF4s2, (list, tuple,np.ndarray)) ==True :
        minF4s2 = minF4s2[0]
        
    # plot ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if plot == True:
        component = trZ.stats.channel
        f, (ax0,ax1, ax2, ax3, ax4,ax5,ax6,ax7)=plt.subplots(8, sharex=True)
        x = range(len(tr_copy.data))
        ax0.plot(x,trN_copy.data)
        ax0.axvline(x=minF4p,color= 'r')
        ax0.axvline(x=minF4s2,color= 'aqua')
        ax0.set_ylabel('$velocity m.s^-1$')
        ax1.plot(x,Cf)
        ax1.plot(x,CfN)
        ax1.axvline(x=minF4p,color= 'r')
        ax1.axvline(x=minF4s2,color= 'aqua')
        ax1.set_ylabel('$Cf$')
        ax2.plot(x, f2)
        ax2.axvline(x=minF4p,color= 'r')
        ax2.axvline(x=minF4s2,color= 'aqua')
        ax2.set_ylabel('$F2$')
        ax3.plot(x,f3meanN)
        ax3.set_ylabel('$F3$')
        ax3.axvline(x=minF4p,color= 'r')
        ax3.axvline(x=minF4s2,color= 'aqua')
        ax4.axvline(x=minF4p,color= 'r')
        ax4.axvline(x=minF4s2,color= 'aqua')
        ax4.plot(x, f4prim)
        ax4.plot(x,f4primN)
        ax4.set_ylabel('$F4$')
        ax5.plot(x,sfilter)
        ax5.axvline(x=minF4p,color= 'r')
        ax5.axvline(x=minF4s2,color= 'aqua')
        ax5.set_ylabel('$sfilter$')
        ax6.plot(x,pfilter)
        ax6.axvline(x=minF4p,color= 'r')
        ax6.axvline(x=minF4s2,color= 'aqua')
        ax6.set_ylabel('$pfilter$')
        ax7.plot(trN_copy, 'k')
        ax7.plot(tr_copyS, 'b')
        ax7.plot(tr_copyP, 'r')
        ax7.axvline(x=minF4p,color= 'r')
        ax7.axvline(x=minF4s2,color= 'aqua')
        ax0.set_title('tr'+component+' Windows time '+ str(T)+'s')    
    return  SecondP+minF4p/df, SecondP+minF4s2/df
