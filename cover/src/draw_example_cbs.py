#! /usr/bin/env python

import numpy as np
import matplotlib
#plot as .pgf (tikz picture) instead of png
matplotlib.use('pgf')
pgf_with_custom_preamble = {
    "pgf.texsystem": "pdflatex",
    "text.usetex": True,    # use inline math for ticks
    "pgf.preamble": [
        r"\usepackage{xfrac}",
        #r"\usepackage{cmbright}",
        #r"\usepackage{units}",         # load additional packages
        #r"\usepackage{metalogo}",
        #r"\usepackage{unicode-math}",  # unicode math setup
        #r"\setmathfont{xits-math.otf}",
        #r"\setmainfont{DejaVu Serif}", # serif font via preamble
    ]
}
matplotlib.rcParams.update(pgf_with_custom_preamble)
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib import colorbar
import matplotlib.patheffects as path_effects
import matplotlib.patches as patches


def calc_lam(CapLam, i=0, numsys=8, w=0.1):
    ome=(CapLam+i*np.pi*2.0/numsys)%(2.*np.pi)
    if ome > np.pi:
        ome=2.0*np.pi-ome
    return ome/np.pi

def drawCirc(ax,radius,centX,centY,angle_,theta2_,lineWidth=3, color_='black'):
    #========Line
    arc = patches.Arc([centX,centY],radius,radius,angle=angle_,
          theta1=0,theta2=theta2_,capstyle='round',linestyle='-',lw=lineWidth,color=color_)
    ax.add_patch(arc)


    #========Create the arrow head
    # endX=centX+(radius/2)*np.cos((theta2_+angle_)/180*np.pi) #Do trig to determine end position
    # endY=centY+(radius/2)*np.sin((theta2_+angle_)/180*np.pi)

    # ax.add_patch(                    #Create triangle as arrow head
    #     patches.RegularPolygon(
    #         (endX, endY),            # (x,y)
    #         3,                       # number of vertices
    #         radius/10,                # radius
    #         (angle_+theta2_)/180*np.pi,     # orientation
    #         color=color_
    #     )
    # )
    
    #========Create the arrow head
    begX=centX+(radius/2)*np.cos((angle_)/180*np.pi) #Do trig to determine end position
    begY=centY+(radius/2)*np.sin((angle_)/180*np.pi)

    ax.add_patch(                    #Create triangle as arrow head
        patches.RegularPolygon(
            (begX, begY),            # (x,y)
            3,                       # number of vertices
            radius/20,                # radius
            (180+angle_)/180*np.pi,     # orientation
            color=color_
        )
    )
    ax.set_xlim([centX-radius,centY+radius]) and ax.set_ylim([centY-radius,centY+radius]) 



def drawConveyorBelt(x, y, CapLam=0.1, M=8, drawArrows=False):
    pSize=2.009
    goldRat=1.70
    lineWidth=1.5
    pathEffects=[] #path_effects.SimpleLineShadow(), path_effects.Normal()]
    fig = plt.figure(figsize=(pSize*goldRat,pSize))
    ax = fig.gca()
    fig.subplots_adjust(left=0.1, right=1.0-0.1, bottom=0.25, top=0.964)
    rx=0.05
    ry=rx
    shifty=0.75/goldRat
    cvb_bot=np.zeros((90,2))
    cvb_bot[:,0]=np.linspace(rx, 1.0-rx, 90)
    cvb_bot[:,1]=np.ones(90)*shifty
    cvb_top=np.zeros((90,2))
    cvb_top[:,0]=np.linspace(rx, 1.0-rx, 90)
    cvb_top[:,1]=np.ones(90)*(shifty+2.0*ry)
    lamVals=x-x.min()
    lamVals/=lamVals.max()
    gVals=y-y.min()
    gVals/=(2.0*gVals.max()*goldRat)
    ax.fill_between(lamVals[2:], gVals[2:])#, 'k', lw=lineWidth, path_effects=pathEffects)

    l=CapLam
    numsys=M
    rotation=[]
    y=[]
    for i in range(M):
        if calc_lam(CapLam, i, numsys=M) > rx and calc_lam(CapLam, i, numsys=M) < (1.0-rx):
            rotation.append(45)
            y.append(1.0)
        elif calc_lam(CapLam, i, numsys=M) < rx:
            alpha=np.arcsin((rx-calc_lam(CapLam, i, numsys=M))/rx)
            if (CapLam+i*2*np.pi/float(M))%(2.*np.pi) < np.pi:
                rotation.append(45+alpha/np.pi*180.0)
            else:
                rotation.append(45-alpha/np.pi*180.0)
            y.append(np.cos(alpha))
        else:
            alpha=np.arcsin((rx-(1-calc_lam(CapLam, i, numsys=M)))/rx)
            if (CapLam+i*2*np.pi/float(M))%(2.*np.pi) < np.pi:
                rotation.append(45-alpha/np.pi*180.0)
            else:
                rotation.append(45+alpha/np.pi*180.0)
            y.append(np.cos(alpha))
    shiftMarker=0.02*np.sqrt(2)
    
    ax.plot(cvb_bot[:,0], cvb_bot[:,1], 'k', lw=lineWidth, path_effects=pathEffects)
    ax.plot(cvb_top[:,0], cvb_top[:,1], 'k', lw=lineWidth, path_effects=pathEffects)
    ax.add_artist(patches.Arc((rx,shifty+ry), 2*rx, 2*ry, theta1=90, theta2=270, lw=lineWidth, path_effects=pathEffects))
    ax.add_artist(patches.Arc((1.0-rx,shifty+ry), 2*rx, 2*ry, theta1=270, theta2=90, lw=lineWidth, path_effects=pathEffects))
    ax.add_artist(patches.Arc((rx,shifty+ry), 1.4*rx, 1.4*ry, lw=lineWidth, path_effects=pathEffects))
    ax.add_artist(patches.Arc((1.0-rx,shifty+ry), 1.4*rx, 1.4*ry, lw=lineWidth, path_effects=pathEffects))
    # ax.annotate(r'$\Lambda=0$', xy=(0.01, shifty+ry), xytext=(-0.05, shifty+ry), va='center', ha='right', fontsize='small', arrowprops=dict(arrowstyle='-', linewidth=lineWidth))
    # ax.annotate(r'$\Lambda=\frac{\pi}{2}$', xy=(0.5,  shifty+2*ry+0.01), xytext=(0.5, shifty+2*ry+0.05), va='bottom', ha='center', fontsize='small', arrowprops=dict(arrowstyle='-', linewidth=lineWidth))
    # ax.annotate(r'$\Lambda=\frac{3\pi}{2}$', xy=(0.5,  shifty-0.01), xytext=(0.5, shifty-0.05), va='top', ha='center', fontsize='small', arrowprops=dict(arrowstyle='-', linewidth=lineWidth))
    # ax.annotate(r'$\Lambda=\pi$', xy=(.99,  shifty+ry), xytext=(1.05, shifty+ry), va='center', ha='left', fontsize='small', arrowprops=dict(arrowstyle='-', linewidth=lineWidth))
    if drawArrows:
        if np.fabs(rotation[0]-45)>0.0001:
            ax.annotate('Current state:\n$\Lambda={:.1f}$'.format(CapLam), xy=(calc_lam(CapLam, 0, numsys=M), shifty+ry+np.cos(alpha)*(ry+shiftMarker)), 
                        xytext=(calc_lam(CapLam, 0, numsys=M) - np.sin(alpha)*2*rx, shifty+(1+np.cos(alpha)*5)*ry), fontsize='small', 
                        arrowprops=dict(arrowstyle='<-', linewidth=1.0, shrinkA=0.0), va='top', ha='center', zorder=0, bbox=dict(pad=-.1, lw=0.0, color='None'))
        else:
            ax.annotate('Current state:\n$\Lambda={:.1f}$'.format(CapLam), xy=(calc_lam(CapLam, 0, numsys=M), shifty+2.0*ry+shiftMarker), 
                        xytext=(calc_lam(CapLam, 0, numsys=M), shifty+6*ry), 
                        arrowprops=dict(arrowstyle='<-', linewidth=1.0, shrinkA=0.0), fontsize='small', va='top', ha='center', zorder=0, bbox=dict(pad=-.1, lw=0.0, color='None'))
#arrows in the conveyor belt
    drawCirc(ax,rx*0.8,rx,shifty+ry,45,270, lineWidth=1.0, color_='red')
    drawCirc(ax,rx*0.8,1.0-rx,shifty+ry,225,270, lineWidth=1.0, color_='red')

    for i in range(M):
        x=calc_lam(CapLam, i, numsys=M)
        if x < rx:
            rx-=np.sqrt(1-y[i]**2)*shiftMarker
        elif x > 1-rx:
            rx+=np.sqrt(1-y[i]**2)*shiftMarker
        if (CapLam+i*2*np.pi/float(M))%(2.*np.pi) < np.pi:
            ax.add_patch(                    #Create triangle as arrow head
                patches.RegularPolygon(
                (x, shifty+ry+y[i]*ry+y[i]*shiftMarker),            # (x,y)
                    4,                       # number of vertices
                    0.02,                # radius
                    rotation[i]/180.0*np.pi,     # orientation
                    color='red',
                    path_effects=pathEffects,
                    zorder=10
                )
            )
            ax.scatter(x, gVals[np.abs(lamVals-x).argmin()]+shiftMarker, s=30, marker='o', edgecolors='face', color='r', zorder=10)
            if drawArrows:
                ax.annotate('', xy=(x, gVals[np.abs(lamVals-x).argmin()]+shiftMarker), xytext=(x+0.1, gVals[np.abs(lamVals-x-0.1).argmin()]+shiftMarker), arrowprops=dict(arrowstyle='<-', linewidth=lineWidth))
            ax.plot([x, x], [gVals[np.abs(lamVals-x).argmin()], shifty+ry+y[i]*ry+y[i]*shiftMarker], color='0.8', lw=lineWidth, zorder=0)
        else:
            ax.add_patch(                    #Create triangle as arrow head
                patches.RegularPolygon(
                    (x, shifty-y[i]*shiftMarker),            # (x,y)
                    4,                       # number of vertices
                    0.02,                # radius
                    rotation[i]/180.0*np.pi,     # orientation
                    color='red',
                    path_effects=pathEffects,
                    zorder=10
                )
            )    
            ax.plot([x, x], [gVals[np.abs(lamVals-x).argmin()], shifty+(1.0-y[i])*ry-y[i]*shiftMarker], color='0.8', lw=lineWidth, zorder=0)
            ax.scatter(x, gVals[np.abs(lamVals-x).argmin()]+shiftMarker, s=30, marker='o', edgecolors='face', color='r', zorder=10)
            if drawArrows:
                ax.annotate('', xy=(x, gVals[np.abs(lamVals-x).argmin()]+shiftMarker), xytext=(x-0.1, gVals[np.abs(lamVals-x+0.1).argmin()]+shiftMarker), arrowprops=dict(arrowstyle='<-', linewidth=lineWidth))


    ax.set_xlim(-0.1,1.1)
    ax.set_ylim(0,1.2/goldRat)    
#    ax.set_xticks([0.0, 0.5, 1.0])
#    ax.set_xticklabels(['0\n(A)', r'$\sfrac{1}{2}$', '1\n(B)'])
#    ax.text(lamVals[-1], gVals[-1]-0.05, 'Free energy profile', ha='right', va='top')
#    ax.xaxis.set_ticks_position('bottom')
#    ax.yaxis.set_ticks_position('left')
    ax.set_xticks([])
    ax.set_yticks([])
    ax.spines['left'].set_color('None')
    ax.spines['bottom'].set_color('None')
    ax.spines['right'].set_color('None')
    ax.spines['top'].set_color('None')

#    yarrow = ax.annotate('', xy=(0,0), 
#                         xytext=(0, 0.5/goldRat), ha='center', va='bottom', arrowprops=dict(arrowstyle='<|-', facecolor='k', linewidth=1.5))
#    ax.text( -0.025, 0.25/goldRat, '$G(\lambda)$', ha='right', va='center', fontsize=14)
#    ax.text(  1.025, 0.0, '$\lambda$', ha='left', va='center', fontsize=14)
    return fig


x = np.linspace(0,1,501)
y = x.copy()


def pot_sintw(lam):
    return (np.sin(lam*np.pi)*(lam-0.5)**2+0.25*lam)/0.2744819387786773

y = pot_sintw(x)
fig = drawConveyorBelt(x, y, CapLam=0.1, M=8, drawArrows=False)
fig.savefig('conveyor_belt_sintw.svg', dpi=400, transparent=True)


