::  whitelist.hoon
::
/-  *whitelist
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  (set @t)
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  `this
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  `this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %whitelist-action
    =/  action  !<($%(action) vase)
    ?-    -.action
        %add
      `this(state (~(put in state) domain.action))
    ::
        %remove
      `this(state (~(del in state) domain.action))
    ==  ==
::  
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ~
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--