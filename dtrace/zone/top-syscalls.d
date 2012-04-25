#!/usr/sbin/dtrace -s

/**
 *
 * This shows the top 10 system calls an the sum of their execution time.
 * Written by Brendan Gregg. Date: 04/19/12
 * This was written for Voxer to help identify possible syscall differences
 * between SmartOS and Linux. 
 *
 */

#pragma D option quiet

BEGIN
{
	trace("Tracing...\n");
}

syscall:::entry
{
	self->start = timestamp;
}

syscall:::return
/self->start/
{
	this->delta = timestamp - self->start;
	@t[probefunc] = sum(this->delta);
	@c[probefunc] = count();
}

END
{
	trunc(@t, 10);
	trunc(@c, 10);
	printf("Top 10 Count:");
	printa(@c);
	printf("Top 10 Total (ns):");
	printa(@t);
}
