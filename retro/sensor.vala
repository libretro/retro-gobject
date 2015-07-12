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
internal enum SensorAccelerometer {
	X,
	Y,
	Z
}

/**
 * TODO Change visibility once the interface have been tested.
 */
internal enum SensorAction {
	ACCELEROMETER_ENABLE,
	ACCELEROMETER_DISABLE
}

/**
 * TODO Change visibility once the interface have been tested.
 */
internal interface Sensor: Object {
	public abstract bool set_sensor_state (uint port, SensorAction action, uint rate);
	public abstract float get_sensor_input (uint port, SensorAccelerometer id);
}

}
