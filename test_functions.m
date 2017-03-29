%function []=test_functions()

clear all
close all

%%% Load trace

data_struct=load('trace_S.mat');

trace=data_struct.trace_S;

%%% Parameters

rsample=100;
first_sample=1100;
% last_sample=1750;
% first_sample=2650;
last_sample=1350;


tic
[A,B,M]=trace2FWkurto(trace,rsample,...
            [1 25;1 10],...
            [0.5 1 2 3 4],...
            1,first_sample,last_sample);
     toc





figure
plot(M(:,1))
 [ind_pick,vals_kurto]=follow_extrem2(M,10,1);

 figure
 plot(filterbutter(3,1,25,rsample,trace))
 ylim=get(gca,'YLIM');
 hold on
 plot([ind_pick ind_pick],ylim,'--r')
 hold off