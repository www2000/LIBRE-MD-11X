# Class for dynamic arrays
#
# Copyright (c) 2018 dynamic arrays authors:
#  Michael Danilov <mike.d.ft402 -eh- gmail.com>
#  Merspieler http://gitlab.com/merspieler
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Useage
# to create a new object: var <name> = dynarr.new();
# to add elements: <name>.add(<element>);
# you can access the full stored array as: <name>.arr
# to get only the used area of the array: var <spliced_array> = <name>.get_spliced()

var dynarr =
{
	new: func(size = 8)
	{
		var this = {parents:[dynarr]};
		this.maxsize = size;
		this.size = 0;
		this.arr = setsize([], size);

		return this;
	},

	# add a new element to the array
	add: func(obj)
	{
		# case there's no space left
		if (me.size + 1 >= me.maxsize)
		{
			# double array size
			me.maxsize *= 2;
			me.arr = setsize(me.arr, me.maxsize);
		}

		# add object and increase used counter
		me.arr[me.size] = obj;
		me.size += 1;
	},

	# delete an element from the array
	del: func(id)
	{
		me.size -= 1;
		for(ii = id; ii < me.size - 1; ii += 1){
			me.arr[ii] = me.arr[ii + 1];
		}
	},

	# returns only the filled part of the array or nil if array is empty
	get_sliced: func()
	{
		if (me.size == 0)
		{
			return nil;
		}

		return me.arr[0:me.size - 1];
	}
};
