;;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;;
.386
.model flat,stdcall
option casemap:none

;;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;;

include egcmu.inc     ; local includes for this file

;;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;;

.code
start:

    invoke GetTickCount            ; get seed for random
    mov RandNum, eax               ; seed random generator with time
 
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
    invoke ExitProcess,eax

;;---------------------------------------------------------------------------;;

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

      ;====================
      ; Put LOCALs on stack
      ;====================

      LOCAL wc   :WNDCLASSEX
      LOCAL msg  :MSG


      ;==================================================
      ; Fill WNDCLASSEX structure with required variables
      ;==================================================

      invoke LoadIcon,hInst,500    ; icon ID
      mov hIcon, eax

      szText szClassName,"Project_Class"
      szText szChildClassName, "Child_Class"

      mov wc.cbSize,         sizeof WNDCLASSEX
      mov wc.style,          CS_HREDRAW or CS_VREDRAW \
                             or CS_BYTEALIGNWINDOW
      mov wc.lpfnWndProc,    offset WndProc
      mov wc.cbClsExtra,     NULL
      mov wc.cbWndExtra,     NULL
      m2m wc.hInstance,      hInst
      mov wc.hbrBackground,  COLOR_BTNFACE+1
      mov wc.lpszMenuName,   NULL
      mov wc.lpszClassName,  offset szClassName
      m2m wc.hIcon,          hIcon
        invoke LoadCursor,NULL,IDC_ARROW
      mov wc.hCursor,        eax
      m2m wc.hIconSm,        hIcon

      invoke RegisterClassEx, ADDR wc

      invoke CreateWindowEx,WS_EX_LEFT,
                            ADDR szClassName,
                            ADDR szDisplayName,
                            WS_OVERLAPPED or WS_SYSMENU,
                            0,0,0,0,
                            NULL,NULL,
                            hInst,NULL
      mov   hWnd,eax

      invoke ShowWindow,hWnd,SW_HIDE
      invoke UpdateWindow,hWnd

      ;invoke SetTimer, hWnd, 1, 5000, NULL
      ;===================================
      ; Loop until PostQuitMessage is sent
      ;===================================

    StartLoop:
      invoke GetMessage,ADDR msg,NULL,0,0
      cmp eax, 0
      je ExitLoop
      invoke TranslateMessage, ADDR msg
      invoke DispatchMessage,  ADDR msg
      jmp StartLoop
    ExitLoop:
      ;invoke KillTimer, hWnd, 1
      return msg.wParam

WinMain endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD


;;===========================================================================;;


.if uMsg == WM_COMMAND

;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;;
 
.elseif uMsg == WM_CREATE

 invoke DialogBoxParam, hInstance, ADDR DlgName,NULL,addr ChildWndProc,NULL    
 return 0

;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;;

.elseif uMsg == WM_SIZE


;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;;


.elseif uMsg == WM_CLOSE

;invoke EndDialog, hWin,NULL


;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;;


.elseif uMsg == WM_DESTROY

  invoke PostQuitMessage,NULL
  return 0 
.endif

;;===========================================================================;;



    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

ChildWndProc PROC hWin:HWND, 
             uMsg:UINT, 
             wParam:WPARAM, 
             lParam:LPARAM

    
LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT


.if uMsg == WM_TIMER


;invoke MessageBox,hWin,ADDR about_string,ADDR DlgName,MB_OK


    .if playflag==1
;invoke MessageBeep, MB_OK
;;;;;;;;;;;;;;;;;;;;;;; Play child as MIDI ;;;;;;;;;;;;;;;;;;;;

;; step through current gene

mov edx, current

lea ebx, (NODE PTR [edx]).data               ;;; 
;invoke GetDlgItemText, hWin, EB_CHILDA, ebx, MAX_TEXT  ;;; 
        
 mov ecx, midipos ;; counter to step through gene                           
           add ebx, ecx         
           mov al, [ebx]     
               
 invoke setnote,al
 add eax,60
 mov cur1note,eax
 invoke midioutshort,90h,cur1note,127



 ;invoke Sleep,300                  
                     
                    inc midipos  
                   .if midipos == MAX_TEXT
                    mov ah, 0
                    mov playflag, ah

                   .endif
                     

;;;;;;;;;;;;;;;;;;; (Play child as MIDI) ;;;;;;;;;;;;;;;;;;;;;

    .elseif playflag==2

;;;;;;;;;;;;;;;;;;;;;;; Play parent as MIDI ;;;;;;;;;;;;;;;;;;;;

;; step through parent

mov edx, tempgene

lea ebx, (NODE PTR [edx]).data               ;;; 
;invoke GetDlgItemText, hWin, EB_CHILDA, ebx, MAX_TEXT  ;;; 
        
 mov ecx, midipos ;; counter to step through gene                           
           add ebx, ecx         
           mov al, [ebx]     
               
 invoke setnote,al
 add eax,60
 mov cur1note,eax
 invoke midioutshort,90h,cur1note,127
 

 ;invoke Sleep,300                  
                     
                    inc midipos  
                   .if midipos == MAX_TEXT
                    mov ah, 0
                    mov playflag, ah

                   .endif
                     

;;;;;;;;;;;;;;;;;;; (Play parent as MIDI) ;;;;;;;;;;;;;;;;;;;;;

    .endif



;;;;;;;;;;;;;

.ELSEIF uMsg == WM_PAINT
        invoke BeginPaint,hWin,ADDR Ps
        mov hDC, eax
        invoke ImageProc,hWin, NULL, NULL, NULL

        ;invoke Paint_Proc,hWin,hDC
        invoke EndPaint,hWin,ADDR Ps




        return 0




    .ELSEIF uMsg==WM_INITDIALOG


   
        invoke SetTimer, hWin, 1, TIMER_DELAY, NULL
    
        invoke GetDlgItem, hWin, PB_PREVGENE ;Get the handle to the "Prev" button
        mov hPrev, eax
        ;invoke EnableWindow, eax, FALSE  ;Disable the "Prev" button

        invoke GetDlgItem, hWin, PB_NEXTGENE ;Get the handle to the "Next" button
        mov hNext, eax
        invoke EnableWindow, eax, FALSE  ;Disable the "Next" button

        invoke GetDlgItem, hWin, PB_RETURN ;Get the handle of the "Return" button
        mov hReturn, eax
        invoke EnableWindow, eax, FALSE    ;Disable it!



        ;invoke GetDlgItem, hWin, EB_NUMCHILDA ;
        ;mov hnumchilda, eax

        ;invoke GetDlgItem, hWin, EB_TOTCHILDA ;
        ;mov htotchilda, eax

;;;;;;;;;;;;;;;;;;;;;;;
; create linked list of max_genes genes.
invoke SetDlgItemText, hWin, EB_PARENTA, addr test_string

;;;;;;;;;;;;; create head

;.IF stub==0                                      ;If there is no root
                        invoke GlobalAlloc, ACCESS_TYPE, SIZEOF NODE ;Create one
                        mov (NODE PTR [eax]).next, 0                 ;Set the terminator
                        mov (NODE PTR [eax]).prev, 0                 ;Set the terminator
                        mov stub, eax                                ;Set the root pointer
                        mov current, eax                             ;Set the current pointer

                        lea eax, (NODE PTR [eax]).data
                      
                        invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1


;;;;;;;;;;;;; (create head)


mov ecx, 1 ;; root == 0, add (maxgenes - 1) more.
.REPEAT
push ecx

;;;;;;;;;;;;; create gene


                       ;.ELSE ;A linked list already exists!
                        
                        invoke GlobalAlloc, ACCESS_TYPE, SIZEOF NODE ;Create a new node
                        mov edx, current               ;Move the current pointer to a reg, ready for use
                        
                        mov ecx, (NODE PTR [edx]).next ;Move the current.next pointer to a reg
                        mov (NODE PTR [eax]).next, ecx ;"Insert" the new node
                        ;; if creating list in order, this could be shortened to:
                        ;; mov (NODE PTR [eax]).next, 0 ;"Insert" the new node

                        mov (NODE PTR [edx]).next, eax ;Make the current point to the new instead


                        ;mov (NODE PTR [ecx]).prev, eax ; prev
                        mov (NODE PTR [eax]).prev, edx ; prev -- assumes in-order build
   
                        lea eax, (NODE PTR [eax]).data

                        invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1
                        ;Fill the allocated space with the data from the edit box

                        invoke EnableWindow, hNext, TRUE
                        ;Make sure the "Next" button is enabled

                        mov edx, current
                        lea eax, (NODE PTR [edx]).data
                        invoke SetDlgItemText, hWin, EB_CHILDA, eax



                        ;Restore the text to that of the current node
                  ;  .ENDIF

                               

;;;;;;;;;;;;; (create gene)

;;;;;;;;;;;;; proceed to next gene

invoke EnableWindow, hPrev, TRUE ;Enable the "Prev" button ;;;
                        
                        mov edx, current
                        mov edx, (NODE PTR [edx]).next
                        ;Make current = current.next

                        lea eax, (NODE PTR [edx]).data
                        push edx ;Store new current for later

                        invoke SetDlgItemText, hWin, EB_CHILDA, eax
                        ;Get appropriate text

                        pop edx ;restore new current

                        mov eax, (NODE PTR [edx]).next
                        mov current, edx ;Save new current over old current
                        
                        .IF eax==0 ;If the next node is the null terminator
                            invoke EnableWindow, hNext, FALSE ;Disable the "Next" button
                        .ENDIF

                        invoke EnableWindow, hReturn, TRUE ;Enable the "Return" button


;;;;;;;;;;;;; (proceed to next gene)

pop ecx
inc ecx
.UNTIL ecx==(max_genes)

;;;;;;;;;;;;; return

mov eax, stub
                        mov current, eax ;Make current = stub

                        lea eax, (NODE PTR [eax]).data

                        invoke SetDlgItemText, hWin, EB_CHILDA, eax
                        invoke EnableWindow, hReturn, FALSE
                        invoke EnableWindow, hNext, TRUE
                        ;Update buttons etc.


;;;;;;;;;;;;; (return)

;;;;;;;;;;;;; temp node

invoke GlobalAlloc, ACCESS_TYPE, SIZEOF NODE ;Create temp gene
mov (NODE PTR [eax]).next, 0                 ;Set the terminator
mov (NODE PTR [eax]).prev, 0                 ;Set the terminator
mov tempgene, eax                            ;Set the root pointer

lea eax, (NODE PTR [eax]).data
invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1

;;;;;;;;;;;;; (temp node)



mov eax, 1             
invoke SetDlgItemInt , hWin, EB_NUMCHILDA, eax, FALSE

mov eax, max_genes               
invoke SetDlgItemInt , hWin, EB_TOTCHILDA, eax, FALSE

mov eax, 1               
invoke SetDlgItemInt , hWin, EB_NUMCHILDB, eax, FALSE

mov eax, max_genes               
invoke SetDlgItemInt , hWin, EB_TOTCHILDB, eax, FALSE


invoke midiOutOpen,ADDR hmidi, -1, 0, 0, 0 ;; open MIDI channel


;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;

    .ELSEIF uMsg==WM_CLOSE
	  invoke SendMessage,hWin,WM_COMMAND,CM_EXIT,0
        ;If closed, act like it was the "Exit" command from the menu

    .ELSEIF uMsg==WM_COMMAND
	  mov eax,wParam
        .IF lParam==0
	      .IF ax==CM_EXIT ;Menu - exit

                 invoke midiOutClose,hmidi

                mov edx, stub ;Start at the root node
                        
                .IF edx!=0                     ;; if a head actually exists...
                .REPEAT
                    push (NODE PTR [edx]).next ;Store the next pointer
                    invoke GlobalFree, edx     ;Delete current pointer
                    pop edx                    ;Move on to the next
                    or edx, edx
                .UNTIL edx==0                  ;; until no nodes exist
                .ENDIF

                mov edx, tempgene ; temp node        
                invoke GlobalFree, edx     ;Delete current pointer
                    
                invoke KillTimer, hWin, 1
                invoke PostQuitMessage,NULL
		    ;invoke EndDialog, hWin,NULL    ;Exit the dialog box proc
	      .ENDIF
        .ELSE
		mov edx,wParam
		shr edx,16
		.IF dx==BN_CLICKED
		   

                  .IF ax==PB_RETURN
                        mov eax, stub
                        mov current, eax ;Make current = stub

                        lea eax, (NODE PTR [eax]).data

                        invoke SetDlgItemText, hWin, EB_CHILDA, eax
                        invoke EnableWindow, hReturn, FALSE
                        invoke EnableWindow, hNext, TRUE
                        ;Update buttons etc.



;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_PLAYPARENT

.if playflag == 4
mov ah, 2 ;; 
mov playflag, ah
.else
mov ah, 2  ;; 2 for parent
mov playflag, ah
mov eax, 0
mov midipos, eax  ;; reset gene to beginning for MIDI
.endif

;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_PLAYCHILD

.if playflag == 3
mov ah, 1 ;; 
mov playflag, ah
.else 
mov ah, 1 ;; 1 for child
mov playflag, ah
mov eax, 0
mov midipos, eax  ;; reset gene to beginning for MIDI
.endif

;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_PAUSEPARENT

.if playflag == 2
mov ah, 4 ;; 
mov playflag, ah
.elseif playflag == 4
mov ah, 2 ;; 
mov playflag, ah
.endif

;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;

                .ELSEIF ax==PB_PAUSECHILD

.if playflag == 1
mov ah, 3 ;; 
mov playflag, ah
.elseif playflag == 3
mov ah, 1 ;; 
mov playflag, ah
.endif
;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_STOPPARENT

mov ah, 0
mov playflag, ah
;mov eax, 0
;mov midipos, eax  ;; reset gene to beginning for MIDI

;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_STOPCHILD

mov ah, 0
mov playflag, ah
;mov eax, 0
;mov midipos, eax  ;; reset gene to beginning for MIDI

;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_FWDPARENT
;; this command is dangerous (may jump past end of gene) and must be revised/removed

inc midipos

;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;
                .ELSEIF ax==PB_FWDCHILD
;; this command is dangerous (may jump past end of gene) and must be revised/removed

inc midipos

;;;;;;;;;;;;;;;;;;;




                .ELSEIF ax==PB_SETPARENTPARENT

mov ah, 0
mov playflag, ah  ;; stop gene from playing

;mov eax, 0
;mov midipos, eax  ;; reset gene to beginning for MIDI

;mov edx, current
;lea eax, (NODE PTR [edx]).data
;invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1
;invoke SetDlgItemText, hWin, EB_PARENTA, eax

mov edx, tempgene
lea eax, (NODE PTR [edx]).data
invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1
invoke SetDlgItemText, hWin, EB_PARENTA, eax

;;; set the parent gene to parent


;;;;; breeding segment

mov edx, stub ;Start at the root node
mov current, edx

.REPEAT    ;; for each gene...

push (NODE PTR [edx]).next ;Store the next pointer
                    
lea eax, (NODE PTR [edx]).data               ;;; set parent to parent
invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1  ;;; 

pushad          
           
                  mov ecx, 0 ;; counter to step through gene
                  .REPEAT           
                  pushad

                  ;;;;;;;;;;;;;;;;; Random Number Generator ;;;;;;;;;;;;;;;;;;
                      mov edx, 0
                      imul    eax,RandNum,19660Dh  ;; this is rng 

                      add     eax, 10DCDh      ;EAX = RandNum * 19660Dh + 10DCDh
                      mov     RandNum,eax      ;Save random number
        
                      mov     ebx, maxrand     ;EBX = maximum 
                                     
                      div     ebx              ;Divide by maximum
                      mov     eax,edx          ;remainder in edx
                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

                      .if eax < mutchance ;; later change to "< mutchance"
                    
                  ;;;;;;;;;;;;;;;;; Random Number Generator ;;;;;;;;;;;;;;;;;;
                      mov edx, 0
                      imul    eax,RandNum,19660Dh  ;; this is rng 

                      add     eax, 10DCDh      ;EAX = RandNum * 19660Dh + 10DCDh
                      mov     RandNum,eax      ;Save random number
        
                      mov     ebx, pot         ;EBX = maximum 
                                     
                      div     ebx              ;Divide by maximum
                      mov     eax,edx          ;remainder in edx
                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             
                      mov gene_byte, dl
                      popad  
                      mov ebx, current
                      lea edx, (NODE PTR [ebx]).data
     
                      mov al, gene_byte
                      add al, char_start
                      mov byte ptr [edx+ecx], al
                      ;mov byte ptr [edx], 63 ;; for testing
                    
                      
                        
                       .else 
                        popad

                      .endif
                      


                      inc ecx
                      .UNTIL ecx==MAX_TEXT
                     

popad
;invoke MessageBox,hWin,ADDR DlgName,ADDR DlgName,MB_OK ;; for testing
pop edx                    ;Move on to the next
or edx, edx ; what is the point of this?
mov current, edx
.UNTIL edx == 0   ;; (...for each gene)

mov edx, stub
mov current, edx

;; redisplay data for gene 1 (otherwise display will be "off") -- 

lea eax, (NODE PTR [edx]).data
invoke SetDlgItemText, hWin, EB_CHILDA, eax

invoke EnableWindow, hNext, TRUE
                        ;Make sure the "Next" button is enabled
invoke EnableWindow, hPrev, FALSE
                        ;Make sure the "Prev" button is disabled


mov eax, 1      ;; reset counter on child         
invoke SetDlgItemInt , hWin, EB_NUMCHILDA, eax, FALSE
invoke ImageProc,hWin, NULL, NULL, NULL


;;;;;;;;;;;;;;;;;;;;


                .ELSEIF ax==PB_SETPARENTCHILD
mov ah, 0
mov playflag, ah  ;; stop gene from playing

mov edx, current
lea eax, (NODE PTR [edx]).data
invoke SetDlgItemText, hWin, EB_PARENTA, eax

mov edx, tempgene
lea eax, (NODE PTR [edx]).data
invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1

;;; set the current gene to parent, set tempgene


;;;;; breeding segment


;mov eax, 0 ;; this is for testing
;mov edx, stub   ;; revise later

mov edx, stub ;Start at the root node
mov current, edx

.REPEAT    ;; for each gene...

push (NODE PTR [edx]).next ;Store the next pointer
                    ;;invoke GlobalFree, edx     ;Delete current pointer
                   
;pop ebx
;mov current, ebx
;push ebx


lea eax, (NODE PTR [edx]).data               ;;; set child to parent
invoke GetDlgItemText, hWin, EB_PARENTA, eax, MAX_TEXT+1  ;;; 

pushad          
           
                  mov ecx, 0 ;; counter to step through gene
                  .REPEAT           
                  pushad

                  ;;;;;;;;;;;;;;;;; Random Number Generator ;;;;;;;;;;;;;;;;;;
                      mov edx, 0
                      imul    eax,RandNum,19660Dh  ;; this is rng 

                      add     eax, 10DCDh      ;EAX = RandNum * 19660Dh + 10DCDh
                      mov     RandNum,eax      ;Save random number
        
                      mov     ebx, maxrand     ;EBX = maximum 
                                     
                      div     ebx              ;Divide by maximum
                      mov     eax,edx          ;remainder in edx
                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;           

                      .if eax < mutchance ;; later change to "< mutchance"
                    
                  ;;;;;;;;;;;;;;;;; Random Number Generator ;;;;;;;;;;;;;;;;;;
                      mov edx, 0
                      imul    eax,RandNum,19660Dh  ;; this is rng 

                      add     eax, 10DCDh      ;EAX = RandNum * 19660Dh + 10DCDh
                      mov     RandNum,eax      ;Save random number
        
                      mov     ebx, pot         ;EBX = maximum 
                                     
                      div     ebx              ;Divide by maximum
                      mov     eax,edx          ;remainder in edx
                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             
                      mov gene_byte, dl
                      popad  
                      mov ebx, current
                      lea edx, (NODE PTR [ebx]).data
     
                      mov al, gene_byte
                      add al, char_start
                      mov byte ptr [edx+ecx], al
                      ;mov byte ptr [edx], 63 ;; for testing
                    
                      
                        
                       .else 
                        popad

                      .endif
                      


                      inc ecx
                      .UNTIL ecx==MAX_TEXT
                     

popad
;invoke MessageBox,hWin,ADDR DlgName,ADDR DlgName,MB_OK ;; for testing
pop edx                    ;Move on to the next
or edx, edx ; what is the point of this?
mov current, edx
.UNTIL edx == 0   ;; (...for each gene)

mov edx, stub
mov current, edx

;; redisplay data for gene 1 (otherwise display will be "off") -- 

lea eax, (NODE PTR [edx]).data
invoke SetDlgItemText, hWin, EB_CHILDA, eax

invoke EnableWindow, hNext, TRUE
                        ;Make sure the "Next" button is enabled
invoke EnableWindow, hPrev, FALSE
                        ;Make sure the "Prev" button is disabled


mov eax, 1  ;; reset counter on child              
invoke SetDlgItemInt , hWin, EB_NUMCHILDA, eax, FALSE
invoke ImageProc,hWin, NULL, NULL, NULL


;;;;;;;;;;;;;;;;;;;;;;;

                .ELSEIF ax==PB_NOTEMAP

invoke DialogBoxParam, hInstance, ADDR NoteMapDlgName, NULL, ADDR NoteMapProc, NULL

;;;;;;;;;;;;;;;;;;;;;;;;

                .ELSEIF ax==PB_ABOUT
                        
                      invoke MessageBox,hWin,ADDR about_string,ADDR about_label,MB_OK


;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;
.ELSEIF ax==PB_PREVGENE

.if stickyflag != 1           
mov ah, 0
mov playflag, ah  ;; stop gene from playing
.endif


invoke GetDlgItemInt , hWin, EB_NUMCHILDA, NULL, FALSE      
dec eax               
invoke SetDlgItemInt , hWin, EB_NUMCHILDA, eax, FALSE


                        mov edx, current
                        .IF edx==stub ;If the previous node is the null terminator
                            invoke EnableWindow, hPrev, FALSE ;Disable the "Prev" button
                            ret
                        .ENDIF


                        ;mov edx, current
                        mov edx, (NODE PTR [edx]).prev
                        ;Make current = current.prev

                        lea eax, (NODE PTR [edx]).data
                        push edx ;Store new current for later

                        invoke SetDlgItemText, hWin, EB_CHILDA, eax
                        ;Get appropriate text

                        pop edx ;restore new current

                        mov eax, (NODE PTR [edx]).prev
                        mov current, edx ;Save new current over old current
                        

                        .IF eax==0 ;If the previous node is the null terminator
                            invoke EnableWindow, hPrev, FALSE ;Disable the "Prev" button
                        .ENDIF


                        invoke EnableWindow, hNext, TRUE ;Enable the "Next" button
                        invoke ImageProc,hWin, NULL, NULL, NULL


;;;;;;;;;;;;;;;;;;;;;;

.elseif ax == CB_STICKYPLAY

   .if stickyflag == 1           
    mov ah, 0
    
       .else          
        mov ah, 1

   .endif
    mov stickyflag, ah  ;; stick/unstick



;;;;;;;;;;;;;;;;;;;;;;


               .ELSEIF ax==PB_NEXTGENE

.if stickyflag != 1           
mov ah, 0
mov playflag, ah  ;; stop gene from playing
.endif

                        invoke EnableWindow, hPrev, TRUE ;Enable the "Prev" button ;;;
  
invoke GetDlgItemInt , hWin, EB_NUMCHILDA, NULL, FALSE      
inc eax               
invoke SetDlgItemInt , hWin, EB_NUMCHILDA, eax, FALSE

 
                        mov edx, current
                        mov edx, (NODE PTR [edx]).next
                        ;Make current = current.next

                        lea eax, (NODE PTR [edx]).data
                        push edx ;Store new current for later

                        invoke SetDlgItemText, hWin, EB_CHILDA, eax
                        ;Get appropriate text

                        pop edx ;restore new current

                        mov eax, (NODE PTR [edx]).next
                        mov current, edx ;Save new current over old current


                        .IF eax==0 ;If the next node is the null terminator
                            invoke EnableWindow, hNext, FALSE ;Disable the "Next" button
                        .ENDIF

                        invoke EnableWindow, hReturn, TRUE ;Enable the "Return" button
                        invoke ImageProc,hWin, NULL, NULL, NULL


		   .ENDIF
		.ENDIF
	  .ENDIF
    .ELSE
        mov eax, FALSE
	  ret
    .ENDIF

    mov eax,TRUE
    ret
ChildWndProc endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

NoteMapProc  proc hWin   :DWORD,
             uMsg        :DWORD,
             wParam      :DWORD,
             lParam      :DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL hDC    :DWORD
    

    .if uMsg == WM_INITDIALOG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

invoke InitCommonControls	        	; 

      invoke GetDlgItem,hWin,PB_TAB1	; We get the handle to the Tab Control
	mov hwndTab,EAX			      ; Store handle
	
	; Here we add the tabs to the tab control
	; Filling the TC_ITEM Struct

	mov ItemStruct.imask,TCIF_TEXT	       ; Choose text/image
	mov ItemStruct.lpReserved1,0			 ; Reserved
	mov ItemStruct.lpReserved2,0 			 ; Reserved
	mov ItemStruct.pszText,OFFSET TabTitle1 	 ; pointer to string containing tab text 
	mov ItemStruct.cchTextMax,sizeof TabTitle1 ; size of pszText
  	mov ItemStruct.iImage,0				 ; index to tab control's image 
 	mov ItemStruct.lParam,0			    	 ; Extra info
	invoke SendMessage,hwndTab,TCM_INSERTITEM,0,OFFSET ItemStruct

	; Create second tab title
	mov ItemStruct.pszText,OFFSET TabTitle2
	mov ItemStruct.cchTextMax,sizeof TabTitle2
	invoke SendMessage,hwndTab,TCM_INSERTITEM,1,OFFSET ItemStruct
  
      ; Create third tab title
	mov ItemStruct.pszText,OFFSET TabTitle3
	mov ItemStruct.cchTextMax,sizeof TabTitle3
	invoke SendMessage,hwndTab,TCM_INSERTITEM,2,OFFSET ItemStruct

      ; Now we add the fourth Tab title
	mov ItemStruct.pszText,OFFSET TabTitle4
	mov ItemStruct.cchTextMax,sizeof TabTitle4
	invoke SendMessage,hwndTab,TCM_INSERTITEM,3,OFFSET ItemStruct

	; Create the tab control dialogs:
	; First child dialog box:
	
      mov eax,OFFSET NoteMapTabProc
	invoke CreateDialogParam,hInstance,OFFSET Child1Name,hwndTab,EAX,0
	mov Child1hWnd, eax

	; Second child dialog box
	mov eax,OFFSET NoteMapTabProc
	invoke CreateDialogParam,hInstance,OFFSET Child2Name,hwndTab,EAX,64
	mov Child2hWnd, eax

      ; Third child dialog box
	mov eax,OFFSET NoteMapTabProc
	invoke CreateDialogParam,hInstance,OFFSET Child3Name,hwndTab,EAX,128
	mov Child3hWnd, eax

      ; Fourth child dialog box
      mov eax,OFFSET NoteMapTabProc
	invoke CreateDialogParam,hInstance,OFFSET Child4Name,hwndTab,EAX,192
	mov Child4hWnd, eax

	mov WhichTabChosen,0 ; Initialize variable with 0 to begin with first child dialog

	invoke ShowWindow,Child1hWnd,SW_SHOWDEFAULT

 ;   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;

.elseif uMsg==WM_NOTIFY
                mov eax,lParam
                mov eax, (NMHDR PTR [eax]).code
                cmp eax, TCN_SELCHANGE
                jz ChangingTab
                ret

ChangingTab:
                mov ebx,WhichTabChosen
                mov eax,[Handles+ebx*4]
                invoke ShowWindow,eax,SW_HIDE
                invoke SendMessage,hwndTab,TCM_GETCURSEL,0,0                                                                                            ; Ok which one is BEING chosen right now?
                mov WhichTabChosen,eax
                mov ebx,[Handles+eax*4]

                invoke ShowWindow,ebx,SW_SHOWDEFAULT
    
;;;;;;;;;;;;;;;;;;




   ;======== menu commands ========
    
.elseif uMsg == WM_COMMAND


        .if wParam==PB_APPLY

mov ecx, 0
.REPEAT
push ecx

;add ecx, EB_NOTE0 
;invoke GetDlgItem, hWin, ecx ;Get the handle to the current notemap window
;mov hNoteMapW, eax

;;;; copy from current window to current spot in NoteMap array
invoke GetDlgItemInt , hWin, EB_NOTE0, NULL, FALSE
;mov word ptr 



pop ecx
inc ecx
.UNTIL ecx==256

invoke EndDialog, hWin,NULL

        ;.elseif wParam==IDCANCEL




        .endif


 

 .elseif uMsg == WM_CLOSE
    invoke EndDialog, hWin,NULL

    .else
    mov eax,FALSE 
    ret
    .endif


    mov eax,TRUE
	ret

NoteMapProc endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

NoteMapTabProc  proc hWin   :DWORD,
                uMsg        :DWORD,
                wParam      :DWORD,
                lParam      :DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL hDC    :DWORD
    

.if uMsg == WM_INITDIALOG

;mov edx, 0
mov edx, lParam
;mov edx, 30
;add lParam, 64

mov ecx, 0
;mov lParam, edx
;add lParam, 64

.REPEAT
push edx
push ecx


lea ebx, notetable

mov eax, 0
mov al, [ebx+edx]

;;;mov eax, 0
mov notesingle, eax

pop ecx
mov ebx, 0
add ebx, EB_NOTE0
add ebx, ecx
push ecx

;;;; copy from current spot in NoteMap array to current window
invoke SetDlgItemInt , hWin, ebx, notesingle, FALSE

pop ecx
pop edx
inc ecx
inc edx
.UNTIL ecx==64 ;;;;;;;;;;;


   ;======== menu commands ========
    
;.elseif uMsg == WM_COMMAND


        ;.if wParam==PB_APPLY



 .elseif uMsg == WM_CLOSE
    invoke EndDialog, hWin,NULL

 ;.endif

    .else
    mov eax,FALSE 
    ret
    .endif

    mov eax,TRUE
	ret


NoteMapTabProc endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

setnote proc notenumber:BYTE

        mov eax, 0
        mov al,notenumber
        ;sal eax, 1 ;; shift left to compensate for byte:word
        lea ebx, notetable
        add ebx, eax
	
        mov al, [ebx]

	ret
setnote endp

;;---------------------------------------------------------------------------;;

;;---------------------------------------------------------------------------;;

packdword PROC i2: DWORD,i3: DWORD,i4: DWORD
	xor	ebx,ebx
	mov	eax,i2
	xor	edx,edx
	mov     ecx,10000h
	mul	ecx
	xchg	ebx,eax
	xor	edx,edx
	mov	eax,i3
	mov     ecx,100h
	mul	ecx
	add	ebx,eax
	mov	eax,i4
	add	eax,ebx
	ret
packdword ENDP

;;---------------------------------------------------------------------------;;
	
;;---------------------------------------------------------------------------;;

midioutshort proc b1:DWORD,b2:DWORD,b3:DWORD
	invoke packdword,b3,b2,b1
	invoke midiOutShortMsg,hmidi,eax
	ret
midioutshort endp

;;---------------------------------------------------------------------------;;


;;---------------------------------------------------------------------------;;

ImageProc    proc hWin   :DWORD,
             uMsg        :DWORD,
             wParam      :DWORD,
             lParam      :DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL hDC    :DWORD
    LOCAL xpos   :DWORD
    LOCAL ypos   :DWORD
    LOCAL bcount :DWORD
    LOCAL colorcode :DWORD

mov colorcode, 0

invoke GetDC, hWin
mov hDC, eax

mov ypos, IMAGEOS_Y
mov xpos, IMAGEOS_X

;;;;;;;;;;;;;;

mov bcount, 0

.REPEAT 

mov edx, current
lea ebx, (NODE PTR [edx]).data               ;;; 
        
mov ecx, bcount ;; counter to step through gene                           
           add ebx, ecx         
           mov bl, [ebx]     


;RGB [ebx], [ebx], [ebx]

mov bh, bl
mov cl, bl

;shr bh, 1
shl bh, 1

;shr cl, 3
shl cl, 2


RGB bl, bh, cl

mov colorcode, eax

invoke SetPixel, hDC, xpos, ypos, colorcode
inc xpos
.if xpos > MAX_X+IMAGEOS_X
 mov xpos, IMAGEOS_X
 inc ypos
.endif
 
inc bcount
.UNTIL bcount==MAX_TEXT

ret
ImageProc endp

;;---------------------------------------------------------------------------;;

;;;;;;


end start

;;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;-;;