; ---------------------------------------------------------------------------

DeleteObject:
		movea.l	a0,a1

ObjectDeleteA1:
		moveq	#0,d1
		moveq	#bytesToLcnt(object_size),d0

.clear:
		move.l	d1,(a1)+
		dbf	d0,.clear
		rts