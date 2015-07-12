/* Copyright (C) 2014  Adrien Plazas
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

namespace Retro {

/**
 * TODO Change visibility once the interface have been tested.
 */
internal enum CameraBuffer {
	OPENGL_TEXTURE,
	RAW_FRAMEBUFFER
}

/**
 * TODO Change visibility once the interface have been tested.
 */
internal interface Camera: Object {
	public abstract uint64 caps { set; get; }
	public abstract uint width { set; get; }
	public abstract uint height { set; get; }

	public abstract bool start ();
	public abstract void stop ();

	public abstract void frame_raw_framebuffer ([CCode (array_length = false)] uint32[] buffer, uint width, uint height, size_t pitch);
	public abstract void frame_opengl_texture (uint texture_id, uint texture_target, [CCode (array_length = false)] float[] affine);

	public abstract void initialized ();
	public abstract void deinitialized ();
}

}
